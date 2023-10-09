Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BDD21A5A4
	for <patches@lists.linux.dev>; Mon,  9 Oct 2023 13:23:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KubjsZEA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9AE9C433C9;
	Mon,  9 Oct 2023 13:23:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1696857814;
	bh=bS1o+BiUUGetM/YN+sxFGQJ8DIbJZgqQM+lZyFdV1vo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KubjsZEA2bjNezEq6jMgCmOFQfXqI8bYER7sy2h9KIL22H/XO3nPc7QA38kuNvNbu
	 b7RZfLpknWK77NktC1QpThEZGhgpnAQ1xQD4/6k5BjZ3TN6MVKDdBF2uMjSXiylrZg
	 n38x1ZyXSnjaeN/PIAPdH4YmxKCXGLNCFXqgrnaY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	John David Anglin <dave.anglin@bell.net>,
	Helge Deller <deller@gmx.de>
Subject: [PATCH 6.1 138/162] parisc: Fix crash with nr_cpus=1 option
Date: Mon,  9 Oct 2023 15:01:59 +0200
Message-ID: <20231009130126.718315265@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231009130122.946357448@linuxfoundation.org>
References: <20231009130122.946357448@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Helge Deller <deller@gmx.de>

commit d3b3c637e4eb8d3bbe53e5692aee66add72f9851 upstream.

John David Anglin reported that giving "nr_cpus=1" on the command
line causes a crash, while "maxcpus=1" works.

Reported-by: John David Anglin <dave.anglin@bell.net>
Signed-off-by: Helge Deller <deller@gmx.de>
Cc: stable@vger.kernel.org # v5.18+
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/parisc/kernel/smp.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/arch/parisc/kernel/smp.c
+++ b/arch/parisc/kernel/smp.c
@@ -443,7 +443,9 @@ int __cpu_up(unsigned int cpu, struct ta
 	if (cpu_online(cpu))
 		return 0;
 
-	if (num_online_cpus() < setup_max_cpus && smp_boot_one_cpu(cpu, tidle))
+	if (num_online_cpus() < nr_cpu_ids &&
+		num_online_cpus() < setup_max_cpus &&
+		smp_boot_one_cpu(cpu, tidle))
 		return -EIO;
 
 	return cpu_online(cpu) ? 0 : -EIO;



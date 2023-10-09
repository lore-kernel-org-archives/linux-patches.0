Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C235619BA9
	for <patches@lists.linux.dev>; Mon,  9 Oct 2023 13:13:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HaqGtHc/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A7ADC433C7;
	Mon,  9 Oct 2023 13:13:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1696857228;
	bh=+iTaA3lwLUsawlzI7j/d3mKGDl4FEHYR2e7X9kayjPQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HaqGtHc/CQ6IJYcayWDYB1r10yn1UZGKHHWgm6enZa/1LjpjzZlUHn3d8+Fh6otbM
	 leAMRjLsDBSinre4ZAD7nmnrVOY6GR8qgrmGe1M5LwqtJLfNDW+DPE649mmrQk679i
	 g9qyzpOzKPT/P0N8CqcTmTgUayk1dvuVhujJ3nhs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	John David Anglin <dave.anglin@bell.net>,
	Helge Deller <deller@gmx.de>
Subject: [PATCH 6.5 139/163] parisc: Fix crash with nr_cpus=1 option
Date: Mon,  9 Oct 2023 15:01:43 +0200
Message-ID: <20231009130127.886119719@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231009130124.021290599@linuxfoundation.org>
References: <20231009130124.021290599@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

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
@@ -440,7 +440,9 @@ int __cpu_up(unsigned int cpu, struct ta
 	if (cpu_online(cpu))
 		return 0;
 
-	if (num_online_cpus() < setup_max_cpus && smp_boot_one_cpu(cpu, tidle))
+	if (num_online_cpus() < nr_cpu_ids &&
+		num_online_cpus() < setup_max_cpus &&
+		smp_boot_one_cpu(cpu, tidle))
 		return -EIO;
 
 	return cpu_online(cpu) ? 0 : -EIO;



Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5053F569D
	for <patches@lists.linux.dev>; Sun, 28 May 2023 19:31:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1111C433EF;
	Sun, 28 May 2023 19:31:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1685302275;
	bh=v5y/d6MFvgPaJmVRMETyzXieC/WwYStzyt+D2FnE6tA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zOW6gf/AQVbVjEg5oAXhvhztd0Sb5C3xzRuNDWflP3mC9OWh0Tfua/uoAdybjew5D
	 3nKQ9jTvdcYraMzjk9y65rSs5SKq1ggBdDbohb1yH+X303/mWeqevLyDKcxGuY8sHT
	 tugDZxaIbUoiGi+hbUCy8MvK+TKXZp6Eh6k4Eodg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Helge Deller <deller@gmx.de>
Subject: [PATCH 6.3 031/127] parisc: Use num_present_cpus() in alternative patching code
Date: Sun, 28 May 2023 20:10:07 +0100
Message-Id: <20230528190837.309019918@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230528190836.161231414@linuxfoundation.org>
References: <20230528190836.161231414@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Helge Deller <deller@gmx.de>

commit b6405f0829d7b1dd926ba3ca5f691cab835abfaa upstream.

When patching the kernel code some alternatives depend on SMP vs. !SMP.
Use the value of num_present_cpus() instead of num_online_cpus() to
decide, otherwise we may run into issues if and additional CPU is
enabled after having loaded a module while only one CPU was enabled.

Signed-off-by: Helge Deller <deller@gmx.de>
Cc: <stable@vger.kernel.org> # v6.1+
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/parisc/kernel/alternative.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/parisc/kernel/alternative.c
+++ b/arch/parisc/kernel/alternative.c
@@ -25,7 +25,7 @@ void __init_or_module apply_alternatives
 {
 	struct alt_instr *entry;
 	int index = 0, applied = 0;
-	int num_cpus = num_online_cpus();
+	int num_cpus = num_present_cpus();
 	u16 cond_check;
 
 	cond_check = ALT_COND_ALWAYS |



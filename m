Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA8A66FC9
	for <patches@lists.linux.dev>; Sun, 17 Sep 2023 19:42:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A5F9C433C8;
	Sun, 17 Sep 2023 19:42:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694979759;
	bh=O6c5xmlACNbV3p/kt57kBXUsGGnySPy9d2nPPcggmCI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dZxW9ZeQy1VOe0R49vcxdDuWUKbEEApWg6lCd/TynvS71bHUsJT62+3qnpT40UsFI
	 yPf/iS1TQ5H/IJqd6i6jUa3Rp4vQwD9/Q5Z0R3xPtsdtsXZBIv7OcW8ozz/PBOv/vh
	 aVWBwzOXUsUEB4Y9Eb0yuLl7X0Jc68utTrnNy1b4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Helge Deller <deller@gmx.de>,
	Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 5.10 406/406] parisc: Drop loops_per_jiffy from per_cpu struct
Date: Sun, 17 Sep 2023 21:14:20 +0200
Message-ID: <20230917191111.976067790@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230917191101.035638219@linuxfoundation.org>
References: <20230917191101.035638219@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Helge Deller <deller@gmx.de>

commit 93346da8ff47cc00f953c7f38a2d6ba11977fc42 upstream.

There is no need to keep a loops_per_jiffy value per cpu. Drop it.

Signed-off-by: Helge Deller <deller@gmx.de>
Cc: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/parisc/include/asm/processor.h |    1 -
 arch/parisc/kernel/processor.c      |    5 ++---
 2 files changed, 2 insertions(+), 4 deletions(-)

--- a/arch/parisc/include/asm/processor.h
+++ b/arch/parisc/include/asm/processor.h
@@ -97,7 +97,6 @@ struct cpuinfo_parisc {
 	unsigned long cpu_loc;      /* CPU location from PAT firmware */
 	unsigned int state;
 	struct parisc_device *dev;
-	unsigned long loops_per_jiffy;
 };
 
 extern struct system_cpuinfo_parisc boot_cpu_data;
--- a/arch/parisc/kernel/processor.c
+++ b/arch/parisc/kernel/processor.c
@@ -163,7 +163,6 @@ static int __init processor_probe(struct
 	if (cpuid)
 		memset(p, 0, sizeof(struct cpuinfo_parisc));
 
-	p->loops_per_jiffy = loops_per_jiffy;
 	p->dev = dev;		/* Save IODC data in case we need it */
 	p->hpa = dev->hpa.start;	/* save CPU hpa */
 	p->cpuid = cpuid;	/* save CPU id */
@@ -440,8 +439,8 @@ show_cpuinfo (struct seq_file *m, void *
 		show_cache_info(m);
 
 		seq_printf(m, "bogomips\t: %lu.%02lu\n",
-			     cpuinfo->loops_per_jiffy / (500000 / HZ),
-			     (cpuinfo->loops_per_jiffy / (5000 / HZ)) % 100);
+			     loops_per_jiffy / (500000 / HZ),
+			     loops_per_jiffy / (5000 / HZ) % 100);
 
 		seq_printf(m, "software id\t: %ld\n\n",
 				boot_cpu_data.pdc.model.sw_id);



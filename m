Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45A5D63B8
	for <patches@lists.linux.dev>; Mon, 20 Feb 2023 13:46:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AEB95C433EF;
	Mon, 20 Feb 2023 13:46:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1676900814;
	bh=Bps+J6UDRFPS9Wp2ZEWdaBrTanEGPs8en/1gsdXGfy0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=L48b3p8BN+ZR5NAL854lwLxJPsc3FFk8Npk2WfTuPJtnomMgxjvRTn8rIroV5P/Cd
	 dmHkXyc+UsdhBPj6pL/D8/kdEfPyWj+Tu35qQhtZkGMuiGApdSYQqhp6zVruGUnnvR
	 SUM4JH50KESBa29OzYszWdNC3Cam3zW3UOcPpEBg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Egorenkov <egorenar@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>
Subject: [PATCH 5.4 038/156] watchdog: diag288_wdt: fix __diag288() inline assembly
Date: Mon, 20 Feb 2023 14:34:42 +0100
Message-Id: <20230220133603.985668989@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230220133602.515342638@linuxfoundation.org>
References: <20230220133602.515342638@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Alexander Egorenkov <egorenar@linux.ibm.com>

commit 32e40f9506b9e32917eb73154f93037b443124d1 upstream.

The DIAG 288 statement consumes an EBCDIC string the address of which is
passed in a register. Use a "memory" clobber to tell the compiler that
memory is accessed within the inline assembly.

Signed-off-by: Alexander Egorenkov <egorenar@linux.ibm.com>
Reviewed-by: Heiko Carstens <hca@linux.ibm.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/watchdog/diag288_wdt.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/watchdog/diag288_wdt.c
+++ b/drivers/watchdog/diag288_wdt.c
@@ -86,7 +86,7 @@ static int __diag288(unsigned int func,
 		"1:\n"
 		EX_TABLE(0b, 1b)
 		: "+d" (err) : "d"(__func), "d"(__timeout),
-		  "d"(__action), "d"(__len) : "1", "cc");
+		  "d"(__action), "d"(__len) : "1", "cc", "memory");
 	return err;
 }
 



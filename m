Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C306620
	for <patches@lists.linux.dev>; Fri,  9 Dec 2022 18:38:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD703C433D2;
	Fri,  9 Dec 2022 18:38:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1670611138;
	bh=eW16Z2d8UklJsHkVDknhAFCX3F1cvZy1MOKL5Ma0f+o=;
	h=From:Date:Subject:To:Cc:From;
	b=KMK1yzYL3QXDlLVZRgQ/7WACKR0mN7T2j2uJ+VskjvYFozdLBVH5lzgp+5DIKK9oY
	 YFfWCPb72u6OoeXI6W2rsCKPfawRDxjRXSxFmddJjj4bL9jso3smleWmNPq8fwfhjx
	 Pe2bkZGMVpKQVnjGeeAyZ2owXL0QYS+6uvkORJBs=
From: Konstantin Ryabitsev <konstantin@linuxfoundation.org>
Date: Fri, 09 Dec 2022 13:38:41 -0500
Subject: [PATCH v2] Makefile: pirate > ninja
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20220921-single-patch-v2-1-8c942b4792db@linuxfoundation.org>
X-B4-Tracking: v=1; b=H4sIALGAk2MC/3WOwQrCMBBEf0X27EqSams8+R/iYZumTSBsJGmLU
 vrvLt49DTPwZmaD6kv0FW6HDYpfY42ZxZjjAVwgnjzGQTwYZYyyRmONPCWPL5pdQH12rTI0ut5a
 EKSn6rEvxC4IxEtKEoZY51w+v4lVizz+tK0aNTaXq6Wua5pBtfcUeXmPeeGBZjl2ymWC577vXzc
 7FVK3AAAA
To: Gee Mailer <mricon@gmail.com>
Cc: Dev Nuller <devnull@kernel.org>, Castor Anxieux <k@castoranxieux.ca>,
 patches@lists.linux.dev,
 Konstantin Ryabitsev <konstantin@linuxfoundation.org>,
 Kay Arr <konstantin.ryabitsev@linux.dev>
X-Mailer: b4 0.11.0-dev-64ef0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1022;
 i=konstantin@linuxfoundation.org; h=from:subject:message-id;
 bh=eW16Z2d8UklJsHkVDknhAFCX3F1cvZy1MOKL5Ma0f+o=;
 b=owGbwMvMwCW27YjM47CUmTmMp9WSGJInNxz0Wqstmqe/62pCveL2WCc3+XuubCFrH92OeHM/Sm7J
 pYAdHaUsDGJcDLJiiixl+2I3BRU+9JBL7zGFmcPKBDKEgYtTACYSt4Hhv3uqxzoBi5ssHJvq+bV6tX
 s7I0yWpdo/s/d46DFz8rHobkaGixt6DlTVzFycXXDl9IbsP0G1D9d62oY9X7XgUoXvIiNdJgA=
X-Developer-Key: i=konstantin@linuxfoundation.org; a=openpgp;
 fpr=DE0E66E32F1FDD0902666B96E63EDCA9329DD07E

Pirates are always better than ninjas.

Cc: Kay Arr <konstantin.ryabitsev@linux.dev>
Signed-off-by: Konstantin Ryabitsev <konstantin@linuxfoundation.org>
---
Here we include some extra info about the series.
---
Changes in v2:
- No changes, just need a new revision
- Link to v1: https://lore.kernel.org/r/20220921-single-patch-v1-1-3589a7733d06@linuxfoundation.org

Changes in v1:
- Taken from junky stuff
---
 Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Makefile b/Makefile
index f41ec8c8426b..695536fb1394 100644
--- a/Makefile
+++ b/Makefile
@@ -3,7 +3,7 @@ VERSION = 6
 PATCHLEVEL = 1
 SUBLEVEL = 0
 EXTRAVERSION = -rc1
-NAME = Hurr durr I'ma ninja sloth
+NAME = Hurr durr I'ma pirate sloth
 
 # *DOCUMENTATION*
 # To see a list of typical targets execute "make help"

---
base-commit: 9abf2313adc1ca1b6180c508c25f22f9395cc780
change-id: 20220921-single-patch-14c602afcb99

Best regards,
-- 
Konstantin Ryabitsev <konstantin@linuxfoundation.org>

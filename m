Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A752F134730;
	Thu, 21 Mar 2024 20:18:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711052304; cv=none; b=JQ4z7wuHzgXpmqRTmpJ4l+rSTYpShc4pxRY5zycies9FhgiAK4fLRecXLy2Main5kt5xcDKH7pvn2CS38CWckW4F2YxvJgUbc3J4AAz5TYIOgPATJ++HPssB3y+n3o6+V5MQHt49bUPD3frsm7lcJiZGIjWNI+A6GNQdAV8OTuw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711052304; c=relaxed/simple;
	bh=lHdoUaJGfgtx37ZWoSqONHz/upAUmFfiL6Db48g557w=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:To:Cc; b=V8iBGttJqJadbBI60/p4Cf0ASwx/9cUvQlxpjY9As9IrASP0sFEj6JXeSOaV7qFGnO7C84I1N4r48Uy43KXzxLDOAohQncNzEpoTyODq0CXznjvbm/c2IxglTJ5JQ+ymc8N4fmk4LFUazka04EVDjVY9pXlir5XaOlGbNhE6UFI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ocXNMM5t; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ocXNMM5t"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06590C433F1;
	Thu, 21 Mar 2024 20:18:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1711052304;
	bh=lHdoUaJGfgtx37ZWoSqONHz/upAUmFfiL6Db48g557w=;
	h=From:Date:Subject:To:Cc:From;
	b=ocXNMM5t0pPRVHJekHzZ2MqlYB4tP0nP8vfil0s2McRJFDbZLnpTfUkbLBH/QTPXC
	 cPHXQDrHL9iBmyZt/hrTQDqRlyi1hYvkscNLQrFNI342mcecqmIggU5ZRnRM/pRJzX
	 Xk73+PC5KVuOLSvu/NG6IY90RmDqUbhjBAdfcFMpbL4akSFbxEFCVOGjSe/yXcGMos
	 3DtiYSTwOLV+cw2EXbhy+sWNCehj6LHT+jwZJc2ZI8/XYEEQQ3l7kaOKwNPg5Tja/X
	 oL6D++L3jT4pRGBkCqI6TiBvjiTjx6rzFyBFPeHtKmlitv3zkQdBdyTIOBUq4aZgQn
	 SUZQTkM6bgAqg==
From: Nathan Chancellor <nathan@kernel.org>
Date: Thu, 21 Mar 2024 13:18:17 -0700
Subject: [PATCH] lkdtm/bugs: Improve warning message for compilers without
 counted_by support
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20240321-lkdtm-improve-lack-of-counted_by-msg-v1-1-0fbf7481a29c@kernel.org>
X-B4-Tracking: v=1; b=H4sIAAiW/GUC/x3NQQqDMBBA0avIrDsQkyLoVUopJjPaQZNIoqKId
 2/o8m3+vyBzEs7QVRck3iVLDAX1owL37cPIKFQMWumnMrrGeaLVo/glxZ1x7t2EcUAXt7Ayfey
 JPo9IxrZKNZYaNlBSS+JBjv/m9b7vH8ttjiB2AAAA
To: keescook@chromium.org
Cc: gustavoars@kernel.org, linux-hardening@vger.kernel.org, 
 patches@lists.linux.dev, Nathan Chancellor <nathan@kernel.org>
X-Mailer: b4 0.14-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=1244; i=nathan@kernel.org;
 h=from:subject:message-id; bh=lHdoUaJGfgtx37ZWoSqONHz/upAUmFfiL6Db48g557w=;
 b=owGbwMvMwCUmm602sfCA1DTG02pJDKl/pvF7Pw/m/xgjcWWCzLPrq1VKqqLL3BK/fcxe/9doy
 z/P5c//dZSyMIhxMciKKbJUP1Y9bmg45yzjjVOTYOawMoEMYeDiFICJ6Hcz/M+Ywp/0mWdF34yt
 JTtP3WS/MaUk5rSDm/sthwc2IY/vJuYyMuy4/1LOaipznQEHlyrDCYfF+v4/vfbNkZ2SuuLOZvM
 uY34A
X-Developer-Key: i=nathan@kernel.org; a=openpgp;
 fpr=2437CB76E544CB6AB3D9DFD399739260CB6CB716

The current message for telling the user that their compiler does not
support the counted_by attribute in the FAM_BOUNDS test does not make
much sense either grammatically or semantically. Fix it to make it
correct in both aspects.

Signed-off-by: Nathan Chancellor <nathan@kernel.org>
---
 drivers/misc/lkdtm/bugs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/misc/lkdtm/bugs.c b/drivers/misc/lkdtm/bugs.c
index b92767d6bdd2..5178c02b21eb 100644
--- a/drivers/misc/lkdtm/bugs.c
+++ b/drivers/misc/lkdtm/bugs.c
@@ -417,7 +417,7 @@ static void lkdtm_FAM_BOUNDS(void)
 	pr_err("FAIL: survived access of invalid flexible array member index!\n");
 
 	if (!__has_attribute(__counted_by__))
-		pr_warn("This is expected since this %s was built a compiler supporting __counted_by\n",
+		pr_warn("This is expected since this %s was built with a compiler that does not support __counted_by\n",
 			lkdtm_kernel_info);
 	else if (IS_ENABLED(CONFIG_UBSAN_BOUNDS))
 		pr_expected_config(CONFIG_UBSAN_TRAP);

---
base-commit: 8d8b79685237b15f4bb676781f6bf241beb068a8
change-id: 20240321-lkdtm-improve-lack-of-counted_by-msg-d3b9006bd6e3

Best regards,
-- 
Nathan Chancellor <nathan@kernel.org>


Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA1F66AA8
	for <patches@lists.linux.dev>; Wed, 20 Jul 2022 17:57:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42F0CC341CA
	for <patches@lists.linux.dev>; Wed, 20 Jul 2022 17:57:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1658339821;
	bh=cTq/7blmzugNf6cBeRiC3Nm8vxzDO8HISzEO/c6LCxE=;
	h=From:Date:Subject:References:In-Reply-To:To:From;
	b=bBol3nla4rAY4FJJfyd6Lx8Fjy+sMv9s1IDgLJjeS6vq0DaoT2LsyiCzC/QJ0c9Je
	 tiPyHICLYr4/k5xbc1qmGGRbYd+4XjCqmzF6W2nQ/AhNvHGIOnbtGEYT7WF2Y/vJqi
	 45C6VxgRK1sFcPw7DRlvx6juV6FUA17tE0lSg39M=
From: Konstantin Ryabitsev <konstantin@linuxfoundation.org>
Date: Wed, 20 Jul 2022 13:57:00 -0400
Subject: [PATCH v3 1/3] Makefile: set appropriate release name
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <20220720-claim-for-kahless-v3-1-7874906a7515@linuxfoundation.org>
References: <20220720-claim-for-kahless-v3-0-7874906a7515@linuxfoundation.org>
In-Reply-To: <20220720-claim-for-kahless-v3-0-7874906a7515@linuxfoundation.org>
To: Linux Patches <patches@lists.linux.dev>
X-Mailer: b4 0.10.0-dev-e2b6f
X-Developer-Signature: v=1; a=openpgp-sha256; l=584;
 i=konstantin@linuxfoundation.org; h=from:subject:message-id;
 bh=cTq/7blmzugNf6cBeRiC3Nm8vxzDO8HISzEO/c6LCxE=;
 b=owGbwMvMwCW27YjM47CUmTmMp9WSGJJuOL5t8RHIM/1+K8RxjXnZxloNN+75n/yDtmsm/UuVc/5S
 OXdXRykLgxgXg6yYIkvZvthNQYUPPeTSe0xh5rAygQxh4OIUgIm8MmZk+BFy7eHir/75B+YEK87X92
 UouLzhWtIrEQd5lV8hXDyzjzP8M9/eECO2S6twA3PC/nvRy/NmLVB8NO+8jKW8UPasZAldPgA=
X-Developer-Key: i=konstantin@linuxfoundation.org; a=openpgp;
 fpr=DE0E66E32F1FDD0902666B96E63EDCA9329DD07E

We are claiming this for Kahless!

Acked-by: Worf son of Mogh <konstantin.ryabitsev@linux.dev>
Reviewed-by: Voq the Pale <konstantin.ryabitsev@linux.dev>
Signed-off-by: Konstantin Ryabitsev <konstantin@linuxfoundation.org>

diff --git a/Makefile b/Makefile
index 00fd80c5dd6e..e6d304ac1abc 100644
--- a/Makefile
+++ b/Makefile
@@ -3,7 +3,7 @@ VERSION = 5
 PATCHLEVEL = 19
 SUBLEVEL = 0
 EXTRAVERSION = -rc7
-NAME = Superb Owl
+NAME = Kahless the Unforgettable
 
 # *DOCUMENTATION*
 # To see a list of typical targets execute "make help"

-- 
b4 0.10.0-dev-e2b6f

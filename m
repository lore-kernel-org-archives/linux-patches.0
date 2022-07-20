Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86E2653A4
	for <patches@lists.linux.dev>; Wed, 20 Jul 2022 14:06:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21840C341CA
	for <patches@lists.linux.dev>; Wed, 20 Jul 2022 14:06:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1658326019;
	bh=N0gNXLYlB9nc3xvp9t0jDc838aXL45sd5aHokUuu5Js=;
	h=From:Date:Subject:References:In-Reply-To:To:From;
	b=pyQyLj9Z4mLYxmaiQd1dpXyD1lXgly+zlya6SLxgQkOikHkd8kRc8VqhFtIwYV/gx
	 kJTn2MqKbua8E3ipnpJuKF7N9ixmPYlfvYIttWYT/zglxDTv1ChSKkJtyyErcfxGfN
	 If8iMvQKYm6dysZ9uTRMsJxXIou/QF4q4Af5qMtc=
From: Konstantin Ryabitsev <konstantin@linuxfoundation.org>
Date: Wed, 20 Jul 2022 10:06:58 -0400
Subject: [PATCH v1 1/2] Makefile: set appropriate release name
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <20220720-claim-for-kahless-v1-1-f787d95bfb7a@linuxfoundation.org>
References: <20220720-claim-for-kahless-v1-0-f787d95bfb7a@linuxfoundation.org>
In-Reply-To: <20220720-claim-for-kahless-v1-0-f787d95bfb7a@linuxfoundation.org>
To: Linux Patches <patches@lists.linux.dev>
X-Mailer: b4 0.10.0-dev-45aaa
X-Developer-Signature: v=1; a=openpgp-sha256; l=463;
 i=konstantin@linuxfoundation.org; h=from:subject:message-id;
 bh=N0gNXLYlB9nc3xvp9t0jDc838aXL45sd5aHokUuu5Js=;
 b=owGbwMvMwCW27YjM47CUmTmMp9WSGJJu8DBJ3UkM2lq4by9v5Oqzbzqd/yaEn93X8UO26/SCebX6
 v306O0pZGMS4GGTFFFnK9sVuCip86CGX3mMKM4eVCWQIAxenAEzk1gdGhvZg3rzZyifaEpda3fDOWB
 HQLNBzuq1A55nSR7HvVaYnDzEyrLkRGOK4NjgpjMvLcnYq99Ok45YVja0ln1QqDCyt7GexAAA=
X-Developer-Key: i=konstantin@linuxfoundation.org; a=openpgp;
 fpr=DE0E66E32F1FDD0902666B96E63EDCA9329DD07E

We are claiming this for Kahless!

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
b4 0.10.0-dev-45aaa

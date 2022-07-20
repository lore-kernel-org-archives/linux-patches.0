Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B967653B0
	for <patches@lists.linux.dev>; Wed, 20 Jul 2022 14:17:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 531DFC341CA
	for <patches@lists.linux.dev>; Wed, 20 Jul 2022 14:17:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1658326655;
	bh=N0gNXLYlB9nc3xvp9t0jDc838aXL45sd5aHokUuu5Js=;
	h=From:Date:Subject:References:In-Reply-To:To:From;
	b=w+Ag2wMRQ2SGkdpQ8M+7L3nXhlZjsTZul/sNAu4Z1F0zrtug/NduOD30N6NLhqBpx
	 KG3PbfNHoOHDJhwMxG0/MKiQQleIddteTtqwWPDaDj6jDfqqPUSHwdVGqrwbBTwrfB
	 MdslsbtvRtp/Y3Qw3kqnzYiwmuKoNl8ZitMbttVA=
From: Konstantin Ryabitsev <konstantin@linuxfoundation.org>
Date: Wed, 20 Jul 2022 10:17:34 -0400
Subject: [PATCH v2 1/3] Makefile: set appropriate release name
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <20220720-claim-for-kahless-v2-1-ddbde3dd27ea@linuxfoundation.org>
References: <20220720-claim-for-kahless-v2-0-ddbde3dd27ea@linuxfoundation.org>
In-Reply-To: <20220720-claim-for-kahless-v2-0-ddbde3dd27ea@linuxfoundation.org>
To: Linux Patches <patches@lists.linux.dev>
X-Mailer: b4 0.10.0-dev-45aaa
X-Developer-Signature: v=1; a=openpgp-sha256; l=463;
 i=konstantin@linuxfoundation.org; h=from:subject:message-id;
 bh=N0gNXLYlB9nc3xvp9t0jDc838aXL45sd5aHokUuu5Js=;
 b=owGbwMvMwCW27YjM47CUmTmMp9WSGJJu8NUrtKpuvG6veHSuQoRwxD//evtVNeYCT4VvL9z1eOmp
 2PbUjlIWBjEuBlkxRZayfbGbggofesil95jCzGFlAhnCwMUpABN5Ycnwz5bz3RNbrmTzyRtsmsQPVi
 RHJDuoJRs8mPP+viZ/4/qVLgz/LE4ebtHIzb2n+Fvq/WYjq6rXtx+/3pcupci7fevtM4w8TAA=
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

Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2E9334B410;
	Tue, 12 May 2026 18:09:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778609370; cv=none; b=ZrUseGyIXs/fV3GXoNth0PV995Yk0kdZCNiqHCLUmAH41Q2hBmQVjqRAlaoNSUjnS1VxFYQNfBDthWGfejQ7nuvKecview7i1vTqvtaw0Pj6AWo8yCIdWu6ABNO6D2NOcqLLupdz/p3ojuNTOhfYoA9Gw+bDfT6iwm9YrDdBaIM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778609370; c=relaxed/simple;
	bh=OPeqWAzarcJ+0Ntkgqf4z6fEuqlNtaz1F0r8LSEj1xY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HsND+ytZ2BD8yaCN3q5FWh1VRx/xGvV9zO5mSGd4XCeRifIEqrQOTGC6xJk66ORjwrbgAwoYDBkm2TXIquoC1VWoK97AcMGhfoUBVRY8KKWaxx/QG0lOORq0+19atYhp5sW5ceddKocYeeRpPl9PJj8qKm/U2dEXYu1fxtki0cI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=T3vWEL+2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="T3vWEL+2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A86AC2BCB0;
	Tue, 12 May 2026 18:09:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778609370;
	bh=OPeqWAzarcJ+0Ntkgqf4z6fEuqlNtaz1F0r8LSEj1xY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=T3vWEL+2+z96i5gPkq5qhOar3lGHBSHW1tkGxvz9tql9qPUZ/6eVnOOiLxzxyXzC4
	 afqHHcyWlanm4s38MnscBDjZAPXyXkhQ6ON0nk4h3WafOqpusNx7hyEQSfnlITxXrQ
	 7zZJfwLdQKOab0hcsimbgLNmg5+wbw4M69H/o2Ig=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joseph Salisbury <joseph.salisbury@oracle.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 7.0 170/307] ASoC: fsl_easrc: fix comment typo
Date: Tue, 12 May 2026 19:39:25 +0200
Message-ID: <20260512173943.707031340@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260512173940.117428952@linuxfoundation.org>
References: <20260512173940.117428952@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Joseph Salisbury <joseph.salisbury@oracle.com>

commit 804dce6c73fdfa44184ee4e8b09abad7f5da408f upstream.

The file contains a spelling error in a source comment (funciton).

Typos in comments reduce readability and make text searches less reliable
for developers and maintainers.

Replace 'funciton' with 'function' in the affected comment. This is a
comment-only cleanup and does not change behavior.

Fixes: 955ac624058f ("ASoC: fsl_easrc: Add EASRC ASoC CPU DAI drivers")
Cc: stable@vger.kernel.org
Signed-off-by: Joseph Salisbury <joseph.salisbury@oracle.com>
Link: https://patch.msgid.link/20260316180545.144032-1-joseph.salisbury@oracle.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/soc/fsl/fsl_easrc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/sound/soc/fsl/fsl_easrc.c
+++ b/sound/soc/fsl/fsl_easrc.c
@@ -1286,7 +1286,7 @@ static int fsl_easrc_request_context(int
 /*
  * Release the context
  *
- * This funciton is mainly doing the revert thing in request context
+ * This function is mainly doing the revert thing in request context
  */
 static void fsl_easrc_release_context(struct fsl_asrc_pair *ctx)
 {



Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15F1B15699E;
	Tue, 30 Jul 2024 16:32:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722357146; cv=none; b=tGgvhW5b/wqiiggjU0oGN+X9TOdLWLqjlESgvNCjP5WlzLLb/i8rGW2JcljjmuAuL3PVqPwmBs7AlRLjs3xP1k6uf1y423btmRqyyRq6S4CcQqJBctNuR/+xMSheOmK2mSgVurkTk8PH7CYnLqMoPapV0kQPy/szXY7rJywyW2k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722357146; c=relaxed/simple;
	bh=m4Bus4ct19wrqO3AwH5RFLlD1eV7IG0vqv48adPGy+Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZRgtQS64PLKsbZLyk2WQALOsvYT/Be1Zuwp5+dAF68+OBuujnwx+DapmqG5CqYUpK5JZC1jtat/puG3R6fB6oX1jbUAFFqAzCglRLS6j7ajnutCH5yub/VZ5V3RhJ4BOBUFVSSx7HKItI9y0nRnYO86bEhY+2PDjLTVx13tbx70=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1D+ktn98; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1D+ktn98"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8462BC4AF0A;
	Tue, 30 Jul 2024 16:32:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722357145;
	bh=m4Bus4ct19wrqO3AwH5RFLlD1eV7IG0vqv48adPGy+Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1D+ktn98QX06TTRDf0i4kR3t25GspvbU/GxxnBogrBL1hZTyvCG4g+f3dssKxGIHw
	 HdFb2qC3TE4KRYT7TWkZAiBYFxXZqb2Ok/HRbAhUApliU6oDULYsmZawSTs8Ou22n0
	 85774+SNpoFKA3yVBaTqSXhOptuwrPH6XWUXgvms=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 263/440] fs/ntfs3: Missed error return
Date: Tue, 30 Jul 2024 17:48:16 +0200
Message-ID: <20240730151626.113650131@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151615.753688326@linuxfoundation.org>
References: <20240730151615.753688326@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>

[ Upstream commit 2cbbd96820255fff4f0ad1533197370c9ccc570b ]

Fixes: 3f3b442b5ad2 ("fs/ntfs3: Add bitmap")
Signed-off-by: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ntfs3/bitmap.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ntfs3/bitmap.c b/fs/ntfs3/bitmap.c
index c055bbdfe0f7c..dfe4930ccec64 100644
--- a/fs/ntfs3/bitmap.c
+++ b/fs/ntfs3/bitmap.c
@@ -1356,7 +1356,7 @@ int wnd_extend(struct wnd_bitmap *wnd, size_t new_bits)
 
 		err = ntfs_vbo_to_lbo(sbi, &wnd->run, vbo, &lbo, &bytes);
 		if (err)
-			break;
+			return err;
 
 		bh = ntfs_bread(sb, lbo >> sb->s_blocksize_bits);
 		if (!bh)
-- 
2.43.0




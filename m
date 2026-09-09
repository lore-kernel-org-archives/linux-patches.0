Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2CF84915B1;
	Wed,  9 Sep 2026 14:24:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788963875; cv=none; b=qGlvi12glE3CHRPMd5AxIMqFEiP6E8E7ng3LUaOVrAabUNyibj/r8Fd48tk+PNaLBBeGHC4hy1d/LDRsqbc6GcVmWPVyJWDES1AQcJC+4bV5aKqz0hC/mTFLnDEhT6fWk30O4du5sGjcTKAFEuUvnG1cHGurPzrI62KxKarW+5E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788963875; c=relaxed/simple;
	bh=KUf4yIwQI+zyU4H/174gUJkZttK7AcDb1wWUjVNmTqg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jx330o75eFkZDSGuzLDriQU02bamtgHS76rwr3fT/XiUweSSAgUzhiKOw5zUkPHA95Y5fz0ob+NE4rsvR6rbCzpyO2uMgkCDyWX3O7oFT8+3cortvMwJFitoerW7EGhflHQ5P+8sPgpwLF7hhmTm5z/d8gzqILZfU9olqG1BnSs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xBB4iven; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xBB4iven"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 371D61F00A3A;
	Wed,  9 Sep 2026 14:24:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788963874;
	bh=1NkRvKFVMlgUsrhALDlqTk8ZwFW0bAcmZ9yvhe1qi7w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xBB4ivenhZyiH6HSEzXCbXBZ9LB2a1u793KErZ8p23EU5t3sq/WvptaXJQgS3t1Q0
	 9w1E6LgsMCxyxMBvGo00cFmTDjGHd4W5YcgLJd4NxxMp8x2dvPYxQnm1FDRlwqRsE7
	 mc1+ocBxZuM8REpw3hOQP2FRRWLalRCLzSSR6RmI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Ujfalusi <peter.ujfalusi@linux.intel.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.18 179/583] ASoC: rt700: drop duplicate reg_default entry
Date: Wed,  9 Sep 2026 15:37:44 +0200
Message-ID: <20260909134244.387589173@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134237.773280130@linuxfoundation.org>
References: <20260909134237.773280130@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Peter Ujfalusi <peter.ujfalusi@linux.intel.com>

commit 90ad6a29809dc53e8c1af23fc51bafe2133da035 upstream.

rt700_reg_defaults[] lists register 0x7303 twice with the same value.  The
identical rt711 table has the entry only once, so this is a copy-paste
error.

Drop the duplicate.  No functional change, regcache_lookup_reg() only ever
finds one of the two entries.

Fixes: 7d2a5f9ae41e ("ASoC: rt700: add rt700 codec driver")
Cc: stable@vger.kernel.org
Signed-off-by: Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
Link: https://patch.msgid.link/20260805090240.16991-5-peter.ujfalusi@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/soc/codecs/rt700-sdw.h |    1 -
 1 file changed, 1 deletion(-)

--- a/sound/soc/codecs/rt700-sdw.h
+++ b/sound/soc/codecs/rt700-sdw.h
@@ -313,7 +313,6 @@ static const struct reg_default rt700_re
 	{ 0x3122, 0x0000 },
 	{ 0x3123, 0x0000 },
 	{ 0x7303, 0x0057 },
-	{ 0x7303, 0x0057 },
 	{ 0x8383, 0x0057 },
 	{ 0x7308, 0x0097 },
 	{ 0x8388, 0x0097 },



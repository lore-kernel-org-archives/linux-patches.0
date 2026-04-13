Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BD7E318ED2;
	Mon, 13 Apr 2026 16:58:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776099486; cv=none; b=gtGrgCQYpqX6Lo0RNq1csTLaHeAZFliOXd9DAADb1kC4T6fE6MVFf26VtMPTSlLS89OaxlS8IsuT/Wqcwr9hr1WPNujgRf5eTX1XJsGDkfVEWquU+mk4itcubEenYtyy/sxtOrO9tIjWNKygL5bd9llPANaYk4U2oNPskD/MLeU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776099486; c=relaxed/simple;
	bh=k3ejfFW8LPXEuCfD+Tx41ALHrK6BunfzUjbqtSCH2D0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kGfhXU7MnkObK5AEo5J8ODiu59kXLR3edZdZvLh23lOhCfaFcc8nAQyMkH1LWvgKMtgUDUb2rR6Lo1Sfx9szigdV6GJPxkQ9L9VvXxNkj7xCJ7Edml6s58lV/pyY1Z61aIyJbm0PX3AwzI+7rd25TdT3163S/FrMMtj+0yvnYhg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=skLFmcAG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="skLFmcAG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7FE7C2BCAF;
	Mon, 13 Apr 2026 16:58:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776099486;
	bh=k3ejfFW8LPXEuCfD+Tx41ALHrK6BunfzUjbqtSCH2D0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=skLFmcAG2zYqZRsL4maV3w53t6AJm7BIOkeBHjwvstdJr+9HBBbVYyXelBuKSPtiW
	 UFtreaZoVuFZ+jgTPnSrBJTQU7QYXPMZTR/15tbW+hrnO3S6NiOBzFsNPh+2QDnzWm
	 AoXNccD8JDwuVADs85PR4qoCmDbgy0S+aKt5CxJA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 359/491] Revert "media: dvb-frontends: w7090p: fix null-ptr-deref in w7090p_tuner_write_serpar and w7090p_tuner_read_serpar"
Date: Mon, 13 Apr 2026 18:00:04 +0200
Message-ID: <20260413155832.476674473@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155819.042779211@linuxfoundation.org>
References: <20260413155819.042779211@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

This reverts commit b3d77a3fc71c084575d3df4ec6544b3fb6ce587d.

Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/dvb-frontends/dib7000p.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/media/dvb-frontends/dib7000p.c b/drivers/media/dvb-frontends/dib7000p.c
index 08b3ac8ff1083..a4d060fb1babd 100644
--- a/drivers/media/dvb-frontends/dib7000p.c
+++ b/drivers/media/dvb-frontends/dib7000p.c
@@ -2198,8 +2198,6 @@ static int w7090p_tuner_write_serpar(struct i2c_adapter *i2c_adap, struct i2c_ms
 	struct dib7000p_state *state = i2c_get_adapdata(i2c_adap);
 	u8 n_overflow = 1;
 	u16 i = 1000;
-	if (msg[0].len < 3)
-		return -EOPNOTSUPP;
 	u16 serpar_num = msg[0].buf[0];
 
 	while (n_overflow == 1 && i) {
@@ -2219,8 +2217,6 @@ static int w7090p_tuner_read_serpar(struct i2c_adapter *i2c_adap, struct i2c_msg
 	struct dib7000p_state *state = i2c_get_adapdata(i2c_adap);
 	u8 n_overflow = 1, n_empty = 1;
 	u16 i = 1000;
-	if (msg[0].len < 1 || msg[1].len < 2)
-		return -EOPNOTSUPP;
 	u16 serpar_num = msg[0].buf[0];
 	u16 read_word;
 
-- 
2.53.0




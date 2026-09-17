Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C95544ABBBF;
	Thu, 17 Sep 2026 16:03:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789661013; cv=none; b=CPuMdsc76y8DdQoeVX9+4tCtqL7ABVX3Cz+NXEZEYwK50B2AX8srJJRZF5hxUhWYma+8mlI1Iix9UzddoxmEdVNVrEwvzMHQfKb6s6p/j1cZy/+0npFCuPrzJFBKyKjKUyynZz3X3lEj6nKqfhJcA3CE1L2FgGE7xP0NX5NHsPI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789661013; c=relaxed/simple;
	bh=gKPMQvnPi3Sz+re9HkmGGTfTnrDU37C4VEbfi1bt5ME=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FytIncDhilIp2a++KdlgrZ9gC6aBbi8d9anTwYJH1AffdW31KBoy6haGWHzW0Gr/8kL9TyfnoGxYinEvxAvMDHvktPg0KFsy+JtMxTv6Xu4zPufZBLMdN/z+lEQmDY0MH0KGtFPKbvYWn96SPzv0TmF+pvdL2ysJW5mTxqe/fEA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=soJzLkCD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="soJzLkCD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E2D11F000FF;
	Thu, 17 Sep 2026 16:03:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789661012;
	bh=tQMFlpy0A7y+Kpx+XiRDz0Exq/uMuLll2yhw5l92bQo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=soJzLkCD8ujb3L63H8H6t9Nkk6k7VfokEwvBBOqS4c7D6SEc9NZJLveTqkZcGGNwI
	 nR3Qr/pnC4I8BOEzUibEfnPoFbXKEKGjr3wRGm4c9KumUhDB8mEwADyriLXVUFI5Em
	 lXQNcK2RqoBaPCHERqSeu4DYmrqGW7vEmh8tz7ek=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ken Lin <kenlin5@quanta.corp-partner.google.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0053/1250] media: platform: cros-ec: Add Kulnex and Moxoe to the match table
Date: Thu, 17 Sep 2026 15:57:28 +0100
Message-ID: <20260917151553.375689535@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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

From: Ken Lin <kenlin5@quanta.corp-partner.google.com>

[ Upstream commit e024767f90f9f50bfcce4b20bb74237ad72450f3 ]

The Google Kulnex and Moxoe device uses the same approach as Google Brask
which enables the HDMI CEC via the cros-ec-cec driver.

Signed-off-by: Ken Lin <kenlin5@quanta.corp-partner.google.com>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/cec/platform/cros-ec/cros-ec-cec.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/media/cec/platform/cros-ec/cros-ec-cec.c b/drivers/media/cec/platform/cros-ec/cros-ec-cec.c
index 419b9a7abcceb..4b3f9bff6067a 100644
--- a/drivers/media/cec/platform/cros-ec/cros-ec-cec.c
+++ b/drivers/media/cec/platform/cros-ec/cros-ec-cec.c
@@ -334,6 +334,10 @@ static const struct cec_dmi_match cec_dmi_match_table[] = {
 	{ "Google", "Dirks", "0000:00:02.0", port_ab_conns },
 	/* Google Moxie */
 	{ "Google", "Moxie", "0000:00:02.0", port_b_conns },
+	/* Google Kulnex */
+	{ "Google", "Kulnex", "0000:00:02.0", port_b_conns },
+	/* Google Moxoe */
+	{ "Google", "Moxoe", "0000:00:02.0", port_b_conns },
 };
 
 static struct device *cros_ec_cec_find_hdmi_dev(struct device *dev,
-- 
2.53.0




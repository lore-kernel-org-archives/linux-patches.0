Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4E0A23762;
	Thu, 18 Jan 2024 11:00:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705575649; cv=none; b=OM7HHTXiCZXOWEG/SpwP2BbFhABM4OpOLa1Si1mkFii8F+uVhbYhUbjghV+Nz/bLUMHrVcArm6pZvlTZLibzGxozagkRakkUzJ/rZx9lCpR5S81k3HUL+KorEZzix/+kLJDAR3XgtJ5Um8bgtBNe6wuRJV7EqvNS0N9HpzHHc6M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705575649; c=relaxed/simple;
	bh=b8vRcPpfiSfwsrrRsEbPV7mFgXBnzAQGXt9KRYQRq7w=;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:User-Agent:X-stable:
	 X-Patchwork-Hint:MIME-Version:Content-Type:
	 Content-Transfer-Encoding; b=LRA41CNwp2OK8iZqVhhcAILooXx9WKRodzBiC0WKRpIwmPXABOa1kQ3tniPx6bwAR2Nzrge8oFGSVsSc8/sCCXwOVjfE07r7hBshVXYssAeiRqCFJJmk9bD5rxTLrRG1WvDLUOjy1Zgy0kw+IONwdCKXiwE8+BEYqMLRuh2tbLA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TGttmUZy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TGttmUZy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA8ACC433C7;
	Thu, 18 Jan 2024 11:00:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705575649;
	bh=b8vRcPpfiSfwsrrRsEbPV7mFgXBnzAQGXt9KRYQRq7w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TGttmUZywBsPIZDy4bLyiqP4TPUASbdfsovv/OzlsAp1Bo3lbWNcA341I1IgdKaqO
	 dUj97JicJt6ARIqh9X5G+1xUFXRupTm7cYdEtz8OKnmFglKaHVPlNkvgWEaGGFMHOm
	 hU+wBlEQokrfH+fJCGBVUHwNUOhhI6ry+ls1+kbA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Jos=C3=A9=20Pekkarinen?= <jose.pekkarinen@foxhound.fi>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 056/100] Input: psmouse - enable Synaptics InterTouch for ThinkPad L14 G1
Date: Thu, 18 Jan 2024 11:49:04 +0100
Message-ID: <20240118104313.350260450@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240118104310.892180084@linuxfoundation.org>
References: <20240118104310.892180084@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: José Pekkarinen <jose.pekkarinen@foxhound.fi>

[ Upstream commit c1f342f35f820b33390571293498c3e2e9bc77ec ]

Observed on dmesg of my laptop I see the following
output:

[   19.898700] psmouse serio1: synaptics: queried max coordinates: x [..5678], y [..4694]
[   19.936057] psmouse serio1: synaptics: queried min coordinates: x [1266..], y [1162..]
[   19.936076] psmouse serio1: synaptics: Your touchpad (PNP: LEN0411 PNP0f13) says it can support a different bus. If i2c-hid and hid-rmi are not used, you might want to try setting psmouse.synaptics_intertouch to 1 and report this to linux-input@vger.kernel.org.
[   20.008901] psmouse serio1: synaptics: Touchpad model: 1, fw: 10.32, id: 0x1e2a1, caps: 0xf014a3/0x940300/0x12e800/0x500000, board id: 3471, fw id: 2909640
[   20.008925] psmouse serio1: synaptics: serio: Synaptics pass-through port at isa0060/serio1/input0
[   20.053344] input: SynPS/2 Synaptics TouchPad as /devices/platform/i8042/serio1/input/input7
[   20.397608] mousedev: PS/2 mouse device common for all mice

This patch will add its pnp id to the smbus list to
produce the setup of intertouch for the device.

Signed-off-by: José Pekkarinen <jose.pekkarinen@foxhound.fi>
Link: https://lore.kernel.org/r/20231114063607.71772-1-jose.pekkarinen@foxhound.fi
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/input/mouse/synaptics.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/input/mouse/synaptics.c b/drivers/input/mouse/synaptics.c
index e43e93ac2798..b6749af46262 100644
--- a/drivers/input/mouse/synaptics.c
+++ b/drivers/input/mouse/synaptics.c
@@ -183,6 +183,7 @@ static const char * const smbus_pnp_ids[] = {
 	"LEN009b", /* T580 */
 	"LEN0402", /* X1 Extreme Gen 2 / P1 Gen 2 */
 	"LEN040f", /* P1 Gen 3 */
+	"LEN0411", /* L14 Gen 1 */
 	"LEN200f", /* T450s */
 	"LEN2044", /* L470  */
 	"LEN2054", /* E480 */
-- 
2.43.0




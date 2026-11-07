Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064247;
	b=PR4win0mKhnEDI9TuXfUFigaOdXfWVElRVxC37VcKx+NXbqXQEK0eIAVlYlDX2n9erl3
	 IzRGADc6hFd+ivWfRrYPcjkRL66yQ6VNMav2Dn7EEq9P5hgGKSHLw+T+BJ3APIqoeNVLn
	 /5dBRPB5MB6AuMTEvR+yunzt9XZYwnmWhJryzDdQjO0df0Hd/2+3BESlFwV1H9i4nB9dq
	 k3aeXQOGIw6LSN42dLNcamDxBc5unEG4W5J6wR15C9NBWMZkPalhlAITFfKaw/yaW2Y0u
	 X1bD1RhI2xOwO9qZG2E3aRnaXwOK8g2risnl1xF/euarV7PxTyhqOX6NREl9uiJQy7A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064247;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=SPGKl5Dntaz3Zld+uTNXIE+ASRdVApClcGa6gmJLAuo=;
	b=Uv/aHJPlHVK6zH4esa+30kjim9Sl69vq+vQlNlL4uHGdeHvfhywuUSL/z+bxFK/DypU+
	 +cDmLq9j0Kzt9QfpQ5ySqliLfKzzepknMmTPC1IkQnVIMTszHJi/r9FNARSfMOKHWLvxR
	 adRkZupLpTXO+Er6/WBNyUN7DhYZHOE9iL8YOfb4X/KYeZhcjKZFkd8bcMETrbv8HaMVk
	 43udPsw/E80Fw+dFGp0OfJPX4JBkTTrKGkGpWEst59p5a+T2l44r2qjcYHRcxIlUgwoES
	 J73oz1kC2s5jApY41YJUOkEfBxIHY336PrPhUow9VZs/ymZO/EAHQwwsQGsbj8MdxAg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="F/qhMrwd";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2EFE7606A332;
	Sat,  7 Nov 2026 15:10:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=F/qhMrwd
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D18191F0089F;
	Sat,  7 Nov 2026 15:10:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064247;
	bh=SPGKl5Dntaz3Zld+uTNXIE+ASRdVApClcGa6gmJLAuo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=F/qhMrwdGDfG/MWVw0LdaeyrYdOgBPrGK8Cy6qi68w8A+tPN1Rr9GyBjym8G4sl+l
	 nZBTkqO/ZgS9P4vcIrkhBQ370ZlniMzY12LOO0aMGXk6VKarp9Z2r0eWIuii21qHKt
	 UzAYlAr5GXQy/AfJNlVkt9HJ12iQM5aLKadYGJjo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot@kernel.org,
	Ariana Lazar <ariana.lazar@microchip.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0350/1257] iio: dac: mcp47feb02: Avoid unjustified probe error on missing label
Date: Sat,  7 Nov 2026 08:44:06 -0500
Message-ID: <20261107134949.062960793@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ariana Lazar <ariana.lazar@microchip.com>

[ Upstream commit bce5b7e29e72538ba61f76c6d534a58ab3838438 ]

Fix unjustified probe error on missing optional 'label' property by
replacing dev_err_probe() with dev_warn_probe(). Correct %pfw usage by
passing the child fwnode handle directly in the error message. Besides the
probe warning a read error is returned at the attempt of reading a null
label.

Fixes: bf394cc80369 ("iio: dac: adding support for Microchip MCP47FEB02")
Reported-by: sashiko-bot@kernel.org
Closes: https://lore.kernel.org/all/20260804134616.1D8A21F00A3E@smtp.kernel.org/
Cc: stable@vger.kernel.org
Signed-off-by: Ariana Lazar <ariana.lazar@microchip.com>
Signed-off-by: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/dac/mcp47feb02.c | 14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

diff --git a/drivers/iio/dac/mcp47feb02.c b/drivers/iio/dac/mcp47feb02.c
index 7758e37080958..baeb1be455c6f 100644
--- a/drivers/iio/dac/mcp47feb02.c
+++ b/drivers/iio/dac/mcp47feb02.c
@@ -921,7 +921,10 @@ static int mcp47feb02_read_label(struct iio_dev *indio_dev, struct iio_chan_spec
 {
 	struct mcp47feb02_data *data = iio_priv(indio_dev);
 
-	return sysfs_emit(label, "%s\n", data->labels[ch->address]);
+	if (data->labels[ch->address])
+		return sysfs_emit(label, "%s\n", data->labels[ch->address]);
+
+	return -ENOENT;
 }
 
 static const struct iio_info mcp47feb02_info = {
@@ -974,10 +977,11 @@ static int mcp47feb02_parse_fw(struct iio_dev *indio_dev,
 
 		set_bit(reg, &data->active_channels_mask);
 
-		ret = fwnode_property_read_string(child, "label", &data->labels[reg]);
-		if (ret)
-			return dev_err_probe(dev, ret, "%pfw: invalid label\n",
-					     fwnode_get_name(child));
+		if (fwnode_property_present(child, "label")) {
+			ret = fwnode_property_read_string(child, "label", &data->labels[reg]);
+			if (ret)
+				dev_warn_probe(dev, ret, "%pfw: invalid label\n", child);
+		}
 
 		chanspec.address = reg;
 		chanspec.channel = reg;
-- 
2.53.0




Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794061932;
	b=k5kh1OjxZIR63xiMDLheeVtGFnAltNJUDKZWAd1NJPCfNwttxD5jWsVklxOlBYpNshTZ
	 vYWOwZZaxDEVr/vYmBKYgmetlwtLDcUmmA6+HinSYEpv+TkDovn+GN/yEfelCwCWzIa+D
	 msBGJu30gcc9Rv8IAH0+IGVqybnUp7DwfJjGqMUUhk2ghITMQuwR6lS5il06LFxcXVQke
	 bftpaw6rOtwJCpHtar+UT/hGOw9uCOBbRJpaq7pl6F2kua3FQBCriO5BSXtsXHvWRKLil
	 XX0UuT9yxv1l5+41A5Jgik3RgPzqg+eP0lzbVa+FZevEd8vNMeYjQ3KuDpk1UUQ6ppg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794061932;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ZgoTHXHdUusaMh1vfsCaQVyQn1Rs/NCBRhA2Ft3K/BM=;
	b=vI/iw2oSknoA8KCmUrzi4wCJc50diQipM9pbGnJNAyHh6DsSo/0Tpz7iYbDSMk4IU8eE
	 sn685tJNZmm/q4RmvQtpeom9HNH2blCefgjl1hDdW+6o9s6Dmf0MNnpBEn/LhED8HJtmN
	 zbM5tFkWv8QwxfNb6oQ9yth9fbQ3iMWFmDAf8HXXMFA5//GON0ExnChHw8gsOVL+0UyA5
	 vEL5zKbPk5WfyvyPvH6NATHktPk/2rxvefwxLaFq77u6baIyVXRnFPbY0LniWCMPhVEvA
	 yZnGH6uszyW2U6FxZg63ln7xcJTYgAm8K0WRiySQaT9S2+gQYQ4hZ63PuRB36sf3vdA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=y6uCqAEE;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EACED606A32D;
	Sat,  7 Nov 2026 14:32:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=y6uCqAEE
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9929F1F0089F;
	Sat,  7 Nov 2026 14:32:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794061931;
	bh=ZgoTHXHdUusaMh1vfsCaQVyQn1Rs/NCBRhA2Ft3K/BM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=y6uCqAEE038P3IvQZdNWKAuZYIq40O+8g7D3V1bj7C4HMvLNC15v7G2PQEkxFtqS9
	 +1cx5pw5I7ydIR0m0f/iseWoEAfmAf+ZcfQw/tXxs2CMYgEZL8hs4U9REqbKxfvj83
	 YEal/alv2MuXjvjYqGI9mztqgO2WRISsv/MXLIdc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linkai Gong <gonglinkai@kylinos.cn>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0935/1536] media: i2c: tc358743: add missing color-space strings
Date: Sat,  7 Nov 2026 08:49:11 -0500
Message-ID: <20261107135023.912754299@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Linkai Gong <gonglinkai@kylinos.cn>

[ Upstream commit cb37e83f1bbdf0964ed0a9524ce45a0694f98205 ]

VI_STATUS3 S_V_COLOR is four bits, so the index after the shift
is 0-15. input_color_space[] only has 14 entries. Add the two
reserved values so log_status() cannot walk off the table.

Fixes: d32d98642de6 ("[media] Driver for Toshiba TC358743 HDMI to CSI-2 bridge")
Cc: stable@vger.kernel.org
Signed-off-by: Linkai Gong <gonglinkai@kylinos.cn>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/i2c/tc358743.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/media/i2c/tc358743.c b/drivers/media/i2c/tc358743.c
index 6a023fe22635a..79a0abd817fec 100644
--- a/drivers/media/i2c/tc358743.c
+++ b/drivers/media/i2c/tc358743.c
@@ -1266,7 +1266,8 @@ static int tc358743_log_status(struct v4l2_subdev *sd)
 	static const char * const input_color_space[] = {
 		"RGB", "YCbCr 601", "opRGB", "YCbCr 709", "NA (4)",
 		"xvYCC 601", "NA(6)", "xvYCC 709", "NA(8)", "sYCC601",
-		"NA(10)", "NA(11)", "NA(12)", "opYCC 601"};
+		"NA(10)", "NA(11)", "NA(12)", "opYCC 601", "NA(14)",
+		"NA(15)"};
 
 	v4l2_info(sd, "-----Chip status-----\n");
 	v4l2_info(sd, "Chip ID: 0x%02x\n",
-- 
2.53.0




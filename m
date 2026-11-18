Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795035852;
	b=EX0BhpQAGgevHwWBDjKtFzZx+H4RBQLspytV/fXVOUbtB3UjqxYJckHABL5zWtDyfbGM
	 zPKz9Xym7+awBgKfKpSIa01IFAkiGyvNuZ42/9EjwAj/dr4uIu5cfMxpgRiSPDpmRUR0e
	 McI8eB80b1dH3dR/kULmktPWj5byPVAzZNFCr0ZClOrKAa9VBOHhCnNIrqY173uioFquE
	 DiTsRew4rDr3BFmORaGZuFvbjsL6Bag1XJfwHYdfAkR5lwfHpfQ32REgaoqRdbDhq60m/
	 gJZ4LDpfKd7HQcZUA7NOk2vke8txj1QfXQspOXz3lB9Y2KypYv7r1PWZoexWbR5EoWw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795035852;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=AwvHlLxGVJHv5+UV1Y0vJGQvp6wTmpv2IuG2Rhi3yco=;
	b=5UXkq8go9CSuaYP/Cl5cTAQr+J8eBgqmaHSEKXKBlLiyudo5xvuxCcap9vYlsT8xV3jC
	 XObtltffIRiPGfIIscT22uHiHSjJRRszt2SnkFZ0Dz8v5kNo1oE8ZqWs0EDNBfHZEjwpQ
	 mkz6eXkh2/4oLvVqvhTEYaTnVTntvXkSxv3aZaNXrGu+mig/EVnbeLuNSeGhDOv10fPgZ
	 CKRDOcTllWRYo35lkvPmO/20viAEIKhkdP88LuTPGL5d3NXNiXpXfJ7JlrCztewihjQks
	 eYWduJCrJ30zZvoydsgJxCjirXfm6WW1dki6kE4O6OoHf3RewFNDggsm/OWLOsnCeGQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FmF8885j;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4E74606BE1C;
	Wed, 18 Nov 2026 21:04:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FmF8885j
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 497F71F000C4;
	Wed, 18 Nov 2026 21:04:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795035851;
	bh=AwvHlLxGVJHv5+UV1Y0vJGQvp6wTmpv2IuG2Rhi3yco=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FmF8885jeTkbaakclMvu2BIjQgsNL5OI5McG8s3jAPNWw6ff479z7OYCJFQt+ApmT
	 yif7OXW4QC8kFC+x5orcdFB97BoXnnXNkQDMeQOmXYzHvtGN1PEH/SyM+anTd0DXCD
	 z+y9TviHyBjl7Cy7T8HHtOB1/LLKrKpig5f+/iLU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linkai Gong <gonglinkai@kylinos.cn>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0833/3318] media: i2c: tc358743: add missing color-space strings
Date: Wed, 18 Nov 2026 15:24:15 +0100
Message-ID: <20261118150344.128006209@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 4b6ad85cf261d..e8af64ed03a7f 100644
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




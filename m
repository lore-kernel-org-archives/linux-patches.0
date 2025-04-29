Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEA4F40C03;
	Tue, 29 Apr 2025 18:08:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745950130; cv=none; b=luqP/2921gIwbnyoS6+RalRjvkFxaDcQssdVev1kCcumXNKV43Hrt7+0z0m77I0vf4Cl26IC1TXSF4ugC+q0xrzkPFKTCVZo/G27KXpRO+foMQFobev7ojsUDw7r7fzfKJz0+8XtDcXiqWkurK0f41rVlJ0tck6oxN1d0SeXjF4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745950130; c=relaxed/simple;
	bh=WXKanP/Wma2fJKNcQaSN6rk3MH7cvaPJrsR9dlwpTIs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gHTX5cLi2+czDokfXEKGdUYsg582KyOiGl9LotwZuzhG7+pQJamjwD8fCmltvzIM+rYWgiLw9Yj40H8JVtImHapZvNb/5mruhL276PlARH97S6O+M44AD+tMwg/RMks+LfiiKMgjSEBnifVzTcqvecKRNNtzWJd+V9qgBJMOz3g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NoNPVcWU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NoNPVcWU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2EFF2C4CEE3;
	Tue, 29 Apr 2025 18:08:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745950130;
	bh=WXKanP/Wma2fJKNcQaSN6rk3MH7cvaPJrsR9dlwpTIs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NoNPVcWUbEbxu3W44UFWgmRbWuMVaA+dRr1qbg0uWlFlzFkohTe8yTHzu8dbjySqg
	 BFEt3uPeNtLlrxs+JzlvDX48m0Y7868t2/ibfc2Xom/qrdT/NHcCGLPjU4NfKmY99i
	 O+ydhBG4tY89RWbpFLWTELTyC+1cY03QCx27yQs8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Amit Pundir <amit.pundir@linaro.org>,
	Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.1 166/167] ASoC: qcom: q6afe-dai: fix Display Port Playback stream name
Date: Tue, 29 Apr 2025 18:44:34 +0200
Message-ID: <20250429161058.440880340@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161051.743239894@linuxfoundation.org>
References: <20250429161051.743239894@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>

commit 4f3fcf5f6dc8ab561e152c8747fd7e502b32266c upstream.

With recent changes to add more display ports did not change the Stream
name in q6afe-dai. This results in below error
"ASoC: Failed to add route DISPLAY_PORT_RX -> Display Port Playback(*)"
and sound card fails to probe.

Fix this by adding correct stream name.

Fixes: 90848a2557fe ("ASoC: qcom: q6dsp: add support to more display ports")
Reported-by: Amit Pundir <amit.pundir@linaro.org>
Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Link: https://lore.kernel.org/r/20230705124850.40069-1-srinivas.kandagatla@linaro.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/soc/qcom/qdsp6/q6afe-dai.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/sound/soc/qcom/qdsp6/q6afe-dai.c
+++ b/sound/soc/qcom/qdsp6/q6afe-dai.c
@@ -496,7 +496,7 @@ static int q6afe_mi2s_set_sysclk(struct
 
 static const struct snd_soc_dapm_route q6afe_dapm_routes[] = {
 	{"HDMI Playback", NULL, "HDMI_RX"},
-	{"Display Port Playback", NULL, "DISPLAY_PORT_RX"},
+	{"DISPLAY_PORT_RX_0 Playback", NULL, "DISPLAY_PORT_RX"},
 	{"Slimbus Playback", NULL, "SLIMBUS_0_RX"},
 	{"Slimbus1 Playback", NULL, "SLIMBUS_1_RX"},
 	{"Slimbus2 Playback", NULL, "SLIMBUS_2_RX"},



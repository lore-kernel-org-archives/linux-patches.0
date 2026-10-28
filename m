Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793213710;
	b=lVIoJu0hH37TE94qZiobZFYuf1FNKosjyPABOkDQ6g/i1U5cigyslvbGsBebfBgCtO9h
	 iqK+CHa0QYxyrQZ88BajmUAo3DM23losG5Zal+0Vz9JIvnGmX0KdJVSdUsU8rMyELY+QJ
	 poIwnp25yCzA7H+st2Dk3wKVwu1HuUXOGFmOtrEDblIYZsGmQ8dQYUVJl4vguAxQxjmyi
	 ewI1AuwPZ49G1UKQZNkPrmMcmz3qA3MrVLTpe99k2io66bVRjKuCaxh07a7uMHEz8abLh
	 jF1HlGrXiGidjHC49ritB4IhbiUdN8DL+JLMgVxBDwcRYtTnifNIQdUyifFHViVSg/w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793213710;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=B+3q47k8QUF2IqGAsCJi0oG6TUyIRjfJXGdoGbklsl0=;
	b=xmbNF4kVeglCbg9TM0I2uWqnJRrnL5Hity/zKpVW2eiyTkhowb/m34LZRRZi4W7UVXDT
	 bWK6hHYsq5RnXIeMd6g1zIr4GNzF6eqI5QPVaGTQ+0xV2gh5+zd8QwjPvTUlGUxCADhbE
	 tXRyYpxtRzLbSkmlbb4SqbpLOA6+plQ3o9+JmLHgjqg+i+FbD4kjZ7GPPuAKpLE8TS/aK
	 b2l9vbPykv5tmqsDkPVYJlfH65TliVmPw+aZdb9A0tT/tlR2my9c23qFptneWIRDHnh0Q
	 hTmft6XeXKDBSC6mnyloe/GPCDwrPGoUtiGcv0eUhF3jn5Qie4nr2RIE0T9ffJtFP/Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=AbBJZNQ6;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C5A1606A31A;
	Wed, 28 Oct 2026 18:55:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=AbBJZNQ6
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F21AE1F01825;
	Wed, 28 Oct 2026 18:55:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793213710;
	bh=B+3q47k8QUF2IqGAsCJi0oG6TUyIRjfJXGdoGbklsl0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AbBJZNQ6tRRtV4hwnd9MCEo2imvXOG8fDFjOcFYOzp1Sz0k0gkya6cqTfj3Xka/2m
	 JpIio5YjpALJMA1UI8ypLz6wAhzFnCuxGoA5EuYbgu2GbfDyo/fXLG1TlTaKDK+6A8
	 Hr8rL3T93LIUMCCKzXNQ82Dywr2n1n9Rp9I6U7zw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Ujfalusi <peter.ujfalusi@linux.intel.com>,
	Ranjani Sridharan <ranjani.sridharan@linux.intel.com>,
	Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
	Bard Liao <yung-chuan.liao@linux.intel.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0602/1887] ASoC: SOF: ipc4-pcm: Workaround for crashed firmware on system suspend
Date: Wed, 28 Oct 2026 17:44:58 +0100
Message-ID: <20261028170513.115448022@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Peter Ujfalusi <peter.ujfalusi@linux.intel.com>

[ Upstream commit c40aad7c81e5fba34b70123ed7ce3397fa62a4d2 ]

When the system is suspended while audio is active, the
sof_ipc4_pcm_hw_free() is invoked to reset the pipelines since during
suspend the DSP is turned off, streams will be re-started after resume.

If the firmware crashes during while audio is running (or when we reset
the stream before suspend) then the sof_ipc4_set_multi_pipeline_state()
will fail with IPC error and the state change is interrupted.
This will cause misalignment between the kernel and firmware state on next
DSP boot resulting errors returned by firmware for IPC messages, eventually
failing the audio resume.
On stream close the errors are ignored so the kernel state will be
corrected on the next DSP boot, so the second boot after the DSP panic.

If sof_ipc4_trigger_pipelines() is called from sof_ipc4_pcm_hw_free() then
state parameter is SOF_IPC4_PIPE_RESET and only in this case.

Treat a forced pipeline reset similarly to how we treat a pcm_free by
ignoring error on state sending to allow the kernel's state to be
consistent with the state the firmware will have after the next boot.

Link: https://github.com/thesofproject/sof/issues/8721
Signed-off-by: Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
Reviewed-by: Ranjani Sridharan <ranjani.sridharan@linux.intel.com>
Reviewed-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Reviewed-by: Bard Liao <yung-chuan.liao@linux.intel.com>
Link: https://msgid.link/r/20240213115233.15716-1-peter.ujfalusi@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/sof/ipc4-pcm.c | 17 +++++++++++++++--
 1 file changed, 15 insertions(+), 2 deletions(-)

diff --git a/sound/soc/sof/ipc4-pcm.c b/sound/soc/sof/ipc4-pcm.c
index 732872395980a..2a8501d14e0af 100644
--- a/sound/soc/sof/ipc4-pcm.c
+++ b/sound/soc/sof/ipc4-pcm.c
@@ -86,7 +86,9 @@ static int sof_ipc4_trigger_pipelines(struct snd_soc_component *component,
 			if (ret < 0) {
 				dev_err(sdev->dev, "failed to pause pipeline %d\n",
 					swidget->pipeline_id);
-				return ret;
+				if (sdev->fw_state != SOF_FW_CRASHED ||
+				    state != SOF_IPC4_PIPE_RESET)
+					return ret;
 			}
 		}
 
@@ -100,7 +102,18 @@ static int sof_ipc4_trigger_pipelines(struct snd_soc_component *component,
 		if (ret < 0) {
 			dev_err(sdev->dev, "failed to set state %d for pipeline %d\n",
 				state, swidget->pipeline_id);
-			break;
+			/*
+			 * workaround: if the firmware is crashed while setting the
+			 * pipelines to reset state we must ignore the error code and
+			 * reset it to 0.
+			 * Since the firmware is crashed we will not send IPC messages
+			 * and we are going to see errors printed, but the state of the
+			 * widgets will be correct for the next boot.
+			 */
+			if (sdev->fw_state != SOF_FW_CRASHED || state != SOF_IPC4_PIPE_RESET)
+				break;
+
+			ret = 0;
 		}
 
 		pipeline->state = state;
-- 
2.53.0




Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6B6D1FBF71;
	Wed,  6 Nov 2024 12:55:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730897720; cv=none; b=Ikk4gcO4j3yHeot4R1ZSO6MrQOsevYjffhaALIpT6wNLEF3pWUXBH7Mfx+VGCaYJgh6wbeCa1bziwalCeKt/b+bq3398XQJ14khws0WbaWnKZsv1lG2r8+Wv0KREZ24ZHisYoLmJjH/zh10Qc2q5/kGQ9DnV4kbDF+q9kWNUQtM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730897720; c=relaxed/simple;
	bh=XYnddLXQHhjvKO4fKCqXng+VHktlA6p4xkZcDol+nC4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NYlyrP88NlzNcQ1V/9YWcwrPfiNuaaTk9AN1Df0FCVPI1nCQnsYN2uFixyFxh70TG3mT9111NPwjNkpSr0XsjXJjSakLcn6T8HbqjgbBr+yxLeVsRBEcNfMIo15OZ2402QweSmLgBXzDsllF+OHyVQ+kEl9AOKVwwa9TigG5CaQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=c6hbA9dM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="c6hbA9dM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4B64C4CECD;
	Wed,  6 Nov 2024 12:55:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730897720;
	bh=XYnddLXQHhjvKO4fKCqXng+VHktlA6p4xkZcDol+nC4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=c6hbA9dM30LglIa8fFrVT7P0q+jinNAvMVClD7Mdq4UkESRguWyO0rSjfU9gR2Jul
	 0xIYMdD4cTtPuU0BV1jZ5djT0prqWcS0cm6oQWVWvyhLZ+1iRMGeZxIO4daOLkOOoO
	 Th3gIFmhFjZcERqxrdHmqX5mV/XPUwH5IZsgSSgc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Ujfalusi <peter.ujfalusi@linux.intel.com>,
	Bard Liao <yung-chuan.liao@linux.intel.com>,
	Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.6 147/151] ASoC: SOF: ipc4-topology: Add definition for generic switch/enum control
Date: Wed,  6 Nov 2024 13:05:35 +0100
Message-ID: <20241106120312.894161753@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120308.841299741@linuxfoundation.org>
References: <20241106120308.841299741@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Peter Ujfalusi <peter.ujfalusi@linux.intel.com>

commit 060a07cd9bc69eba2da33ed96b1fa69ead60bab1 upstream.

Currently IPC4 has no notion of a switch or enum type of control which is
a generic concept in ALSA.

The generic support for these control types will be as follows:
- large config is used to send the channel-value par array
- param_id of a SWITCH type is 200
- param_id of an ENUM type is 201

Each module need to support a switch or/and enum must handle these
universal param_ids.
The message payload is described by struct sof_ipc4_control_msg_payload.

Signed-off-by: Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
Reviewed-by: Bard Liao <yung-chuan.liao@linux.intel.com>
Reviewed-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Link: https://lore.kernel.org/r/20230919103115.30783-2-peter.ujfalusi@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/soc/sof/ipc4-topology.h |   19 ++++++++++++++++++-
 1 file changed, 18 insertions(+), 1 deletion(-)

--- a/sound/soc/sof/ipc4-topology.h
+++ b/sound/soc/sof/ipc4-topology.h
@@ -319,7 +319,7 @@ struct sof_ipc4_copier {
 /**
  * struct sof_ipc4_ctrl_value_chan: generic channel mapped value data
  * @channel: Channel ID
- * @value: gain value
+ * @value: Value associated with @channel
  */
 struct sof_ipc4_ctrl_value_chan {
 	u32 channel;
@@ -343,6 +343,23 @@ struct sof_ipc4_control_data {
 	};
 };
 
+#define SOF_IPC4_SWITCH_CONTROL_PARAM_ID	200
+#define SOF_IPC4_ENUM_CONTROL_PARAM_ID		201
+
+/**
+ * struct sof_ipc4_control_msg_payload - IPC payload for kcontrol parameters
+ * @id: unique id of the control
+ * @num_elems: Number of elements in the chanv array
+ * @reserved: reserved for future use, must be set to 0
+ * @chanv: channel ID and value array
+ */
+struct sof_ipc4_control_msg_payload {
+	uint16_t id;
+	uint16_t num_elems;
+	uint32_t reserved[4];
+	DECLARE_FLEX_ARRAY(struct sof_ipc4_ctrl_value_chan, chanv);
+} __packed;
+
 /**
  * struct sof_ipc4_gain_params - IPC gain parameters
  * @channels: Channels



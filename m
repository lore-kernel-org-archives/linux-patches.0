Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793216722;
	b=poeq7DplPzz91UiPqJC4xfVAheiUHNN0P5q7wP1iJC9g8aoG/f8A9ps5J8bfAsecE70G
	 pItrnxEwib0UwVm5eUNXixHGoKggDpel07wk4ME0YAXC0MUEvbhv377kC4BYmcFVzPlVC
	 oo5LoimkS+Te4VGXNEdjRekoTxB4k5pVTgQ53tQ/hGdzNHOsUoqAhzUpMbtHJHp04eLA8
	 kJff7OiBPFhaEmLNtr0MQte4uKAwdiPqpo2yNS1p0krzCJKunlJhDRZYGAX2M0v44SNnq
	 Dj9ZHlMf1waw7dacKQYXbo/QMaGruWxO4i4K64V3P6htP501rc00X68Lro046L4l8wg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793216722;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=/IpOwopAyovlXH1XFsrfTKDKa/j9FjwNPnFNwCPqjEU=;
	b=CcEbo/0qedqyAj9bVpZj3rWGnrcqP5wI2bW9ivMdlTATZ7hEifaIcclLLSC7jfBmwMB2
	 0xDF/drvZrjd7Hdacae2rT1eLFu7YcOCaNCsz2DZnGc0ZaBFR86OMJigJ/RoyughkxP6e
	 X4iAz+eCada7iQujU1rc86bfKxHv++jgJBqQOFo3arMvzBVAiNdQlT9JOmYvUywHlGl7u
	 9RtVmm/ET3J419I7qiivITbnLkRPTntNOS2xPbupdfeCuAHdJ8lYFHUffWIEXt7daUCkO
	 r15DsDxiwNwM6buuew320G6mk3mqV7rKDpVKjlBdmWu+k6j+KZWlVKdffOHKWONXGjw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jBQwQQTu;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92D41606A31A;
	Wed, 28 Oct 2026 19:45:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jBQwQQTu
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2DD61F01825;
	Wed, 28 Oct 2026 19:45:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793216722;
	bh=/IpOwopAyovlXH1XFsrfTKDKa/j9FjwNPnFNwCPqjEU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jBQwQQTuyDKozyzPiEHOGQA7ED4DXDhw4FcUtzt6yVqtwZIPXyRn/7pFU/0xQivtG
	 zOhGp580uqBizP1HWhFN6jxLI/keA9Om2lP7WOSlFocRW4g85JflC1gjnSLTVC/xy7
	 xZZjjsUeOGPdxXpW23CALuCPrXQs9jd2PXCRyMhk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1657/1887] wifi: iwlwifi: mvm: add a check on the tid coming from the firmware
Date: Wed, 28 Oct 2026 18:02:33 +0100
Message-ID: <20261028170537.165027171@linuxfoundation.org>
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

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

[ Upstream commit 0e4c0d83267261cf67ec9690856edf4a56bb7dfc ]

ba_notif->tid is a firmware-controlled u8 that is used directly
as an array index into tid_data[] without any validation. Add a
bounds check against IWL_MAX_TID_COUNT before dereferencing the
array.

Assisted-by: GitHubCopilot:gpt-5.3-codex
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
Link: https://patch.msgid.link/20260715215523.d7c3e75d47af.If88948108cfc8b5fb3ce5531d927855d1b3b6b30@changeid
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/mvm/tx.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/tx.c b/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
index d04fa56e645e7..456cd91d56216 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
@@ -2126,6 +2126,10 @@ void iwl_mvm_rx_ba_notif(struct iwl_mvm *mvm, struct iwl_rx_cmd_buffer *rxb)
 	ba_notif = (void *)pkt->data;
 	sta_id = ba_notif->sta_id;
 	tid = ba_notif->tid;
+	if (tid >= IWL_MAX_TID_COUNT) {
+		IWL_WARN(mvm, "invalid TID %d in BA notif\n", tid);
+		return;
+	}
 	/* "flow" corresponds to Tx queue */
 	txq = le16_to_cpu(ba_notif->scd_flow);
 	/* "ssn" is start of block-ack Tx window, corresponds to index
-- 
2.53.0




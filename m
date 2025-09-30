Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9045C266B65;
	Tue, 30 Sep 2025 15:07:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759244866; cv=none; b=k1bOQvBGe45f73yO+k7bZE8DkmniYGE4cGluBXYDEa87WeWbLrCUigAZfegbwjs2PcBNjgiDQILaGONRn32LC3RYAM09z6Pr26CtKWOm89kxqSr++TweatTHkGQGokE3id849L111faW/AjxXjiFTbAiLuiWSCh6ZRFB/Ka4L/g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759244866; c=relaxed/simple;
	bh=ASG9BmfpRktW1n5njYmyef0O2t8FQQ4go2DNlhEkY0I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FK1fhl0nWt7k2bfuys0ro6c0z1C3ENrdn6Uz6BSmVrt8XOcD/48yVF/1vayzVrPxYIgDiQYy760EgHOV8iCod+3nFJZcPB5mTW3Q2J3sbKpT0knKyxWEVVH9iya8rw5nzwnr71R2oDrDhXyP1igMu9gJxbpO2kkByk2dNX+8E3Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BbZLWtZR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BbZLWtZR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A109DC4CEF0;
	Tue, 30 Sep 2025 15:07:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1759244866;
	bh=ASG9BmfpRktW1n5njYmyef0O2t8FQQ4go2DNlhEkY0I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BbZLWtZRzS890jSeOXmt+88yynJpyfn9TSWGAI+CkUXnrgHwzWFe7Rv7K9UgaQgYb
	 gW2eJ2pJgL/zLJ+UavFzcgvRjTRsqRqTLG1QJxP750yGJzGxZt5Yh50zEEFm6/kfOx
	 zWl3qOhiX/EdN02jlgXqk5oxo2/NcMgAx2vcf8FE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Wang <00107082@163.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>
Subject: [PATCH 6.16 138/143] wifi: iwlwifi: pcie: fix byte count table for some devices
Date: Tue, 30 Sep 2025 16:47:42 +0200
Message-ID: <20250930143836.735830887@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250930143831.236060637@linuxfoundation.org>
References: <20250930143831.236060637@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johannes Berg <johannes.berg@intel.com>

commit a38108a23ab558b834d71d542d32c05ab0fb64d4 upstream.

In my previous fix for this condition, I erroneously listed 9000
instead of 7000 family, when 7000/8000 were already using iwlmvm.
Thus the condition ended up wrong, causing the issue I had fixed
for older devices to suddenly appear on 7000/8000 family devices.
Correct the condition accordingly.

Reported-by: David Wang <00107082@163.com>
Closes: https://lore.kernel.org/r/20250909165811.10729-1-00107082@163.com/
Fixes: 586e3cb33ba6 ("wifi: iwlwifi: fix byte count table for old devices")
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
Link: https://patch.msgid.link/20250915102743.777aaafbcc6c.I84404edfdfbf400501f6fb06def5b86c501da198@changeid
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireless/intel/iwlwifi/pcie/tx.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/wireless/intel/iwlwifi/pcie/tx.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/tx.c
@@ -2093,7 +2093,7 @@ static void iwl_txq_gen1_update_byte_cnt
 		break;
 	}
 
-	if (trans->mac_cfg->device_family >= IWL_DEVICE_FAMILY_9000 &&
+	if (trans->mac_cfg->device_family >= IWL_DEVICE_FAMILY_7000 &&
 	    trans->mac_cfg->device_family < IWL_DEVICE_FAMILY_AX210)
 		len = DIV_ROUND_UP(len, 4);
 



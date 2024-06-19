Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 507CB4D9EA;
	Wed, 19 Jun 2024 13:26:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718803589; cv=none; b=ubeCDQ9UW2nGtWI/Qcg+K1F1aj+VwTEQD1jRk1Z8JsMX2oX/q4wYMyfZUemU8VmmG0U6oCVc4Acw7UfObys9NXiHRFQPRGW9KSsqreLpat7hV5WTwTF5gvTs0B2oHN5K6+xNsgecTZ9Jl+WRBW/QXcTfVln9ZHP50V+Hl+4f8R8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718803589; c=relaxed/simple;
	bh=kMhqCOABOcu35zxKJk0WXMP1bykZ0JnN3d506EeS9zA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=L7OEoEQjo5m6x0ZMW8GsLaz357DHQR9mN6cMQsjgxmz17el6wPah2n7Ka8zCsW+x7TlY8LtjmwosB27DSJDzVvA5ebImxZebF9a5s9opTYvzWFyueP4mlKG6NwNRkG60MkWu0nGKlwq4aiOQQyS+XQPyRBhRJOK15+fJPL2KDQU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=A8GgxRsk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="A8GgxRsk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7048C2BBFC;
	Wed, 19 Jun 2024 13:26:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718803589;
	bh=kMhqCOABOcu35zxKJk0WXMP1bykZ0JnN3d506EeS9zA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=A8GgxRskwFzyDKTJHtYAjSTOSQ8GM3MUAR2Xh2h/hPsJ4znykWo0lzS64P6PVHg79
	 O/yZd/YpSd1986BbhSlbUU5nkG1tmDAjtSW9oJexkjjVcqmpDD17PHdOjz8/J/GqEx
	 1F84UJQ8emLZKKjk+fJq8FGXWNk8JxUdJA2y/rL8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shahar S Matityahu <shahar.s.matityahu@intel.com>,
	Luciano Coelho <luciano.coelho@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 007/217] wifi: iwlwifi: dbg_ini: move iwl_dbg_tlv_free outside of debugfs ifdef
Date: Wed, 19 Jun 2024 14:54:10 +0200
Message-ID: <20240619125556.787588886@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240619125556.491243678@linuxfoundation.org>
References: <20240619125556.491243678@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shahar S Matityahu <shahar.s.matityahu@intel.com>

[ Upstream commit 87821b67dea87addbc4ab093ba752753b002176a ]

The driver should call iwl_dbg_tlv_free even if debugfs is not defined
since ini mode does not depend on debugfs ifdef.

Fixes: 68f6f492c4fa ("iwlwifi: trans: support loading ini TLVs from external file")
Signed-off-by: Shahar S Matityahu <shahar.s.matityahu@intel.com>
Reviewed-by: Luciano Coelho <luciano.coelho@intel.com>
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
Link: https://msgid.link/20240510170500.c8e3723f55b0.I5e805732b0be31ee6b83c642ec652a34e974ff10@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/iwl-drv.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-drv.c b/drivers/net/wireless/intel/iwlwifi/iwl-drv.c
index 5eba1a355f043..024c37062a60b 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-drv.c
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-drv.c
@@ -1750,8 +1750,8 @@ struct iwl_drv *iwl_drv_start(struct iwl_trans *trans)
 err_fw:
 #ifdef CONFIG_IWLWIFI_DEBUGFS
 	debugfs_remove_recursive(drv->dbgfs_drv);
-	iwl_dbg_tlv_free(drv->trans);
 #endif
+	iwl_dbg_tlv_free(drv->trans);
 	kfree(drv);
 err:
 	return ERR_PTR(ret);
-- 
2.43.0




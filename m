Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E415B18E025;
	Tue, 17 Jun 2025 16:11:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750176718; cv=none; b=GfY7c99Soa0oZ0JyFZg74x7VWuJwiILs5pzji2790IK6oYagzRYHo3CSPaUqE3lEqRIEcbOTTLWb5iDlvzE0Q03EQsd32E9tfBGlq3AFbW79jjvV4fyUAl4YnSKcpQwlR95tbypTow56CaX4oxcC8OIjL430gHLirxQRbCyhtgU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750176718; c=relaxed/simple;
	bh=pc/rBwwxbJwCi2MT75IgIB8ZuY0+J7ocBcJ+F74wrbk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Avj1Mpf37Bl91Unxr65W2sO1JAcwrSAzZsdfG6umryNS3V+JHtVlbewE0RONn1m0DbYcuArY04JolqlXusGvYIEKJ7TBxqaHTCnfEcwOajoEXzJrKiUqSFoaRsrEXlsiIKzlSGT3uUA871LVFGjT/1r4m22F+JJxwlmRvnfsJ0M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CsR3ZuQY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CsR3ZuQY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11084C4CEE3;
	Tue, 17 Jun 2025 16:11:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750176717;
	bh=pc/rBwwxbJwCi2MT75IgIB8ZuY0+J7ocBcJ+F74wrbk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CsR3ZuQYPCqgL66VCPSEUwy6UK+yECmAfHFvvmcFz+6a12OZSH1WrmMdvdq+3qWmZ
	 MZUSVRR1b0c6u+kUct/C2bmeiwZsgDtCzmu0O8tbzJYfi0T65whsW2mnepIaYOie66
	 ClH6GHN3ZhJ4RP3sOfi9kngYv3aPyP4NydDx0XQA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 219/780] wifi: iwlwifi: re-add IWL_AMSDU_8K case
Date: Tue, 17 Jun 2025 17:18:47 +0200
Message-ID: <20250617152500.376157048@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152451.485330293@linuxfoundation.org>
References: <20250617152451.485330293@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Miri Korenblit <miriam.rachel.korenblit@intel.com>

[ Upstream commit bdd6d93d7a109ba1080336fe07d0b4eb815efaf9 ]

This case in iwl_trans_get_rb_size_order was accidently combined with
the IWL_AMSDU_12K case. Fix this.

Fixes: 7391b2a4f7db ("wifi: iwlwifi: rework firmware error handling")
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
Link: https://patch.msgid.link/20250423091408.ef19205aa358.Ifbf89e7b7391cd7070267b7360c53230b3b2c57c@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/iwl-trans.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-trans.h b/drivers/net/wireless/intel/iwlwifi/iwl-trans.h
index ce4954b0d5246..44a249a753ecf 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-trans.h
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-trans.h
@@ -328,6 +328,7 @@ iwl_trans_get_rb_size_order(enum iwl_amsdu_size rb_size)
 	case IWL_AMSDU_4K:
 		return get_order(4 * 1024);
 	case IWL_AMSDU_8K:
+		return get_order(8 * 1024);
 	case IWL_AMSDU_12K:
 		return get_order(16 * 1024);
 	default:
-- 
2.39.5




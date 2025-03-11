Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D8C125EFB4;
	Tue, 11 Mar 2025 15:38:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741707486; cv=none; b=vEcJFYvUTA9nIhI8pdxLfDr8vL9a4sZboJbQhdqWHCeEX3uO7X9W1uMX9BTX+Si3mZ/Pq3XypgCLOiqE/UjBUIJm1vfpdQ3llaGNMHsxYQWoOwG/ODZfFWpbnWjrUeDh0s+HLpClU/ERgmmFyZsMSFEdd+tsvzeOIdzC0MaLf3w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741707486; c=relaxed/simple;
	bh=w5fD5+8qb2KnQkWF6ASXfpE7oGWu9PBFDF4auzgb1iM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jnC0yOzrDqVY/Ku+1j/lMQEHEf9E5lIrFvsgMQ6IoJzcx66skfKPu97U/wwu3J6HSsiAERsqKcMQ+t+HBwNjitTysawZS29KLpwwAm/hJOWmSh5s65dwftgQ79VyZ2erBYcU917BSXwGSZFpnzDsNFq7+7FKipLYmY2pHD4mdqE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mMRd5wRB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mMRd5wRB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12C16C4CEEC;
	Tue, 11 Mar 2025 15:38:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741707486;
	bh=w5fD5+8qb2KnQkWF6ASXfpE7oGWu9PBFDF4auzgb1iM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mMRd5wRB6bay/HGuB9Rtcd0YVNGtzU4x3rIqUtUsierg6zS59+O1jNtoDAjKoUF7p
	 mwdbKYgZ9hPMO21ywdVQe0HlpPSICxIFksv1zbORX+nONPu+desNpghNWlSoTV+BbA
	 Ibybgm/jj49MNt1Lzgm4sxGYviruQTmc06Q24bkk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Berg <johannes.berg@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 405/462] wifi: iwlwifi: limit printed string from FW file
Date: Tue, 11 Mar 2025 16:01:11 +0100
Message-ID: <20250311145814.331859421@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250311145758.343076290@linuxfoundation.org>
References: <20250311145758.343076290@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johannes Berg <johannes.berg@intel.com>

[ Upstream commit e0dc2c1bef722cbf16ae557690861e5f91208129 ]

There's no guarantee here that the file is always with a
NUL-termination, so reading the string may read beyond the
end of the TLV. If that's the last TLV in the file, it can
perhaps even read beyond the end of the file buffer.

Fix that by limiting the print format to the size of the
buffer we have.

Fixes: aee1b6385e29 ("iwlwifi: support fseq tlv and print fseq version")
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
Link: https://patch.msgid.link/20250209143303.cb5f9d0c2f5d.Idec695d53c6c2234aade306f7647b576c7e3d928@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/iwl-drv.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-drv.c b/drivers/net/wireless/intel/iwlwifi/iwl-drv.c
index bf00c2fede746..47eea2c2a739e 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-drv.c
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-drv.c
@@ -1127,7 +1127,7 @@ static int iwl_parse_tlv_firmware(struct iwl_drv *drv,
 
 			if (tlv_len != sizeof(*fseq_ver))
 				goto invalid_tlv_len;
-			IWL_INFO(drv, "TLV_FW_FSEQ_VERSION: %s\n",
+			IWL_INFO(drv, "TLV_FW_FSEQ_VERSION: %.32s\n",
 				 fseq_ver->version);
 			}
 			break;
-- 
2.39.5




Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00CB426F47A;
	Tue,  8 Apr 2025 12:58:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744117092; cv=none; b=UuE5g/roVwPNQ8aw4HspwZebdG8wOl04shj7+EwB7wt1KCKXmV96rrhrcjWawCv/5Ui2iR72jWWeIw/gBAR1LO28ofSKOEQnJyIADrhqX/gQpcbNNfZB2EWICBhh1tPZWiXGEckvXWO0++hpHuQmZZrGzNUOVlgHGFv5FbuT7ZU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744117092; c=relaxed/simple;
	bh=BM02EWpfhS9UbruKs/5KKrWhVhAYpsccph48mqoM/Wg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BRVuQ0xEatSUSymvC9zzubPWHvcbF1CbGzkZln80aLTCNuWXURWtq6bxrHON2DE6kDWnoqngnoNwbVy7zC3lUiPGjiLj42Fo3A/ZIzosCr4Ob2eYa6CJ6Y4GAZp6+pVGNsSBxOmcHPYV+uJx0NSyrhEjyZI7qn3ej6kztaZjog0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TxQMTT4t; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TxQMTT4t"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1DB0CC4CEEA;
	Tue,  8 Apr 2025 12:58:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744117091;
	bh=BM02EWpfhS9UbruKs/5KKrWhVhAYpsccph48mqoM/Wg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TxQMTT4tfFCWNXglZNIhunSuG7Dz0nYoxsenyp862C4BAdDDc0kTR8DJGYRucELGH
	 XoekehXVMzi/IHuZfHJQA8SRiSRBhd2w2ipyWEbDADM3ripORBYd5ZF/MhbaB5J+Gm
	 JQHVFj4kDkYuBZ7yUaYWDBNn9b43hH63SBS9qZfI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Lobakin <aleksander.lobakin@intel.com>,
	Joe Damato <jdamato@fastly.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Yifei Liu <yifei.l.liu@oracle.com>
Subject: [PATCH 6.12 380/423] idpf: Dont hard code napi_struct size
Date: Tue,  8 Apr 2025 12:51:46 +0200
Message-ID: <20250408104854.729371665@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104845.675475678@linuxfoundation.org>
References: <20250408104845.675475678@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Joe Damato <jdamato@fastly.com>

commit 49717ef01ce1b6dbe4cd12bee0fc25e086c555df upstream.

The sizeof(struct napi_struct) can change. Don't hardcode the size to
400 bytes and instead use "sizeof(struct napi_struct)".

Suggested-by: Alexander Lobakin <aleksander.lobakin@intel.com>
Signed-off-by: Joe Damato <jdamato@fastly.com>
Acked-by: Alexander Lobakin <aleksander.lobakin@intel.com>
Link: https://patch.msgid.link/20241004105407.73585-1-jdamato@fastly.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
[Yifei: In Linux-6.12.y, it still hard code the size of napi_struct,
adding a member will lead the entire build failed]
Signed-off-by: Yifei Liu <yifei.l.liu@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/intel/idpf/idpf_txrx.h |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/net/ethernet/intel/idpf/idpf_txrx.h
+++ b/drivers/net/ethernet/intel/idpf/idpf_txrx.h
@@ -438,7 +438,8 @@ struct idpf_q_vector {
 	__cacheline_group_end_aligned(cold);
 };
 libeth_cacheline_set_assert(struct idpf_q_vector, 112,
-			    424 + 2 * sizeof(struct dim),
+			    24 + sizeof(struct napi_struct) +
+			    2 * sizeof(struct dim),
 			    8 + sizeof(cpumask_var_t));
 
 struct idpf_rx_queue_stats {



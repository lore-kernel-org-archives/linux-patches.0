Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 802AF3FD148;
	Mon, 11 May 2026 14:22:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778509321; cv=none; b=iBGKarfSpsdDzCYy+zduDllHpwokDFTg6i3VQvs+N31w2hyxppGuKod5POW3PN7vo8I87l5UiiRyzrDIQIWDkmJBRBrZb+fdcMJqExStJnH8db96D5zXDzd8lBeWKOFWhr5QK/Vwc9/zDsT/LLPCGrijnPX0vRpgMB83+LjShSE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778509321; c=relaxed/simple;
	bh=dRXw4u3okeMOJW15zSl76yiOMH33UjZ2nlLM+YyN4io=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=caVCdu8xLe5P0cWraVPdmUIUExYy09uSwUfSTlzdwTVCKaW7bLYyOrEgZokabKRCUNExNNy/6bAdmaEF3v2QdGupJQYopZca2o9+qTx/eH1xUK6ULnsFkYgqiuQoAfFsu8P+QlDSwQbEPl8ZOkeFq9R+f2oQ4lbg5uNWZZ68Gfw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hbAzJg9d; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hbAzJg9d"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04D79C2BCC9;
	Mon, 11 May 2026 14:21:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778509321;
	bh=dRXw4u3okeMOJW15zSl76yiOMH33UjZ2nlLM+YyN4io=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hbAzJg9dfvqjPx98Xnp1EbKNs5yBILPEFHSP4nFeGec7uUCNT/vSAEK+ExfXqK1fm
	 tefM9pU+CY5OgeW4YuUG2XuDZEFyocBH3KaQSyFKXqLtZDVTZjrAvCpHJr78ZnHA7s
	 7ohA4ygxjr7Mi29e0nA43sBXQwiGDoo3GzR8TX6jNx3gGpmr6HO0unhDSX6x1IhrBT
	 8ZRWFh/Ncz4KiA3VQBDQDM86bqkuSln3poibg1HrVp31FLeVRjI2Biohue7EMK3U9P
	 BFaAoJwBvRdA9YpgkRadsK0/p/NRZcP8FdWXQYfDfQeZJbabe/1hxsEYJTBiHwnAvN
	 zf0QyZNAWpqbQ==
From: Sasha Levin <sashal@kernel.org>
To: gregkh@linuxfoundation.org,
	stable@vger.kernel.org,
	zzzccc427@gmail.com
Cc: Sasha Levin <sashal@kernel.org>,
	patches@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	marcel@holtmann.org,
	johan.hedberg@gmail.com,
	luiz.dentz@gmail.com,
	linux-bluetooth@vger.kernel.org,
	luiz.von.dentz@intel.com,
	Fang Wang <32840572@qq.com>
Subject: Re: [PATCH 6.1.y 2/2] Bluetooth: btintel: serialize btintel_hw_error() with hci_req_sync_lock
Date: Mon, 11 May 2026 10:21:51 -0400
Message-ID: <20260511141441.stable-reply-0002@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <tencent_3D46FCA5631E9197F2E9E88FB394E389B707@qq.com>
References: <tencent_3D46FCA5631E9197F2E9E88FB394E389B707@qq.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Mon, May 11, 2026 at 02:35:39PM +0800, Fang Wang wrote:
> From: Cen Zhang <zzzccc427@gmail.com>
>
> [ Upstream commit 94d8e6fe5d0818e9300e514e095a200bd5ff93ae ]
>
> btintel_hw_error() issues two __hci_cmd_sync() calls (HCI_OP_RESET
> and Intel exception-info retrieval) without holding
> hci_req_sync_lock().

Queued for 6.1 (along with 1/2 as the prerequisite), thanks.

--
Sasha

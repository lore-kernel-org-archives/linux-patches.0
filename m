Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792428917;
	b=1Y8y5QmyDt+OoxmIKr6cGDmgbKY/MIfnY8AIAkNfNRHeO6lOCnIIOQjoEQSPowD14NyY
	 kGirfdYsT7mHEUxs2U1QqrahoTxLaTOFdXAF+z4mJQaRfs8BxTApTdS/mm12aA522TxT4
	 PjkdhmFLgPh0bqqXUdgfnqHsCb98p9sLzf+dJ6RARKG81kPa6miVT9yPK4xZlUfKfErm2
	 l8ks3kO8T8OXelVcAEkDaLfp8AGYlZjMD2xikc2g446H1y4PCxOEIaHLu5PBv18Oz5tnO
	 1E5OmlXLGKexoMmh6q5OtQSprhO+r+IPn5f+vQ7P7LgajqBrUEYJY5f/mXgvtdXjbtg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792428917;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Type:
	 Content-Transfer-Encoding;
	bh=sdfZDzlgFOCMN+lfYVgM3wS0q+yXu8/yEGGnQwZkTwg=;
	b=3+oG1+U1GeAVab1JGeZnzqiVeowTcM6rsW4MaeqVU5GRqKiX+oXYrUm5+9hQA90po+l8
	 OxGVmWbdly1DXe+uONQSQY214NJWz9dkD0R/8vXHtVaKTvadn5pEopkC7kJ+1gxrkdBXr
	 UqL9lGso9pQdDAJIUpI1GpeAy4Rzz0fgoXZwCUSdX3U7NOeDFTy3N/KhXbbTM3lf5J+i6
	 mDhoPOHKWVXo/d9t4J0niJGS5m5NaIJAl6FQFmZrCm0C5mmPB3uhH6Uo8dnoGuWRjGzbc
	 ISKmLVr/l7XuEmN73JhGZdSOF2ZYEXdC1UGQZ0k0VWDIj7wV0msTnEHKBrVtzEqUXfQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="MKwEHn2/";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51E7F606A325;
	Mon, 19 Oct 2026 16:55:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=MKwEHn2/
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3844F1F000C6;
	Mon, 19 Oct 2026 16:55:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792428917;
	bh=sdfZDzlgFOCMN+lfYVgM3wS0q+yXu8/yEGGnQwZkTwg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MKwEHn2/CV3xV6c7PMDFGxVovdDU2gvcrOXKF6KOHL0izWUOzQD+ZPwpnjTwH/f6a
	 3MsElj6FIpQmJv1iW99Z3NtY10sswXlS5TRkSpV9Q7yge8iUerLriq+vqM3kPmzzVg
	 h4tvazDnxdz/mzL59hDrRJ/iou6gIayHad2JASzIVgihpG9HB49nU4e+xjrUbDWsZS
	 9DYxVFDJ6OW7F8zxW4EvRgsWye+wFSx/9NUqH9ICBpU9vBjf+ObjnsrtUYncNZItC0
	 Z2EHlgnSHArZfSiKjxIx4HuPkT9rY3+s8NkcUtgFiTjH6l/JO02i8S1BNHpweSwcp/
	 VMgEHDK8Az/4w==
From: Sasha Levin <sashal@kernel.org>
To: Kang Yang <kang.yang@oss.qualcomm.com>
Cc: Sasha Levin <sashal@kernel.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	stable@vger.kernel.org,
	patches@lists.linux.dev,
	Loic Poulain <loic.poulain@oss.qualcomm.com>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Subject: Re: [PATCH 6.6 0773/1674] wifi: ath10k: shutdown driver when hardware is unreliable
Date: Mon, 19 Oct 2026 12:54:36 -0400
Message-ID: <rc-reply-0008-ad36d3ebfe84@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <b79e28ed-f780-4179-bd60-2f1d3a3c800a@oss.qualcomm.com>
References: <20261017160431.119607952@linuxfoundation.org> <20261017160450.945650442@linuxfoundation.org> <b79e28ed-f780-4179-bd60-2f1d3a3c800a@oss.qualcomm.com>
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On Mon, Oct 19, 2026 at 11:12:18AM +0800, Kang Yang wrote:
> Should add below patches too:
>
> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=f35a07a4842a88801d9182b1a76d178bfa616978
>
> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=54a5b38e4396530e5b2f12b54d3844e860ab6784

Thanks. Rather than adding f35a07a4842a and 54a5b38e4396, I dropped
c256a94d1b1b ("wifi: ath10k: shutdown driver when hardware is
unreliable") together with its prerequisites from the 6.6 and 6.1
queues:

  - bc2ef64931c2 ("wifi: ath10k: replace ENOTSUPP with EOPNOTSUPP")
    (6.6 and 6.1)
  - b1dc0ba41431 ("wifi: ath10k: Update Qualcomm Innovation Center,
    Inc. copyrights") (6.1 only)

Your 2026-09-25 ath-next series "wifi: ath10k: fix recovery and WEDGED failure
handling" carries further Fixes: tags for both c256a94d1b1b and f35a07a4842a.
It can be revisited once that series lands upstream.

-- 
Thanks,
Sasha

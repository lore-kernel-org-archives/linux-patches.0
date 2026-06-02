Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18096395AED;
	Tue,  2 Jun 2026 18:21:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780424514; cv=none; b=pDQ2JvtfQb0iCx/NZWcd+thws1bBkngazFzogzTvMk4E0AxJ+94ArmDSIzt8Wrgd5+PvuVWGYQhvVyXNE3S0ErmlL25h2s/MN69tmzXvN3YhYfIjHCsJAvxgw1K/uq5OT8loLqiVXM+4Nbdeb58HjfyoqxeEg7Sv5nzbxmeQsO0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780424514; c=relaxed/simple;
	bh=i2L3+R0ep+uqSS2+EisTUcxiMofV8C0uAgvH2dIF+pk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Js0unmZ684a6IQ91grkVldv0IPvk/8ZDBnNkdZ0NcFtBWtj5+axzTytDiqZivs8O/HnZNhmzqkDm5sxyqb3jmUQ2jr6vXZowyqvD5RksMe1DgPLwzu3gZqgAvnsOAA3InbVkL72MfZ8+hSSbIi7fzIM783FHkEgpDRlfSR2z0Go=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=c1Un9/rk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="c1Un9/rk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F200B1F0089C;
	Tue,  2 Jun 2026 18:21:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780424513;
	bh=i2L3+R0ep+uqSS2+EisTUcxiMofV8C0uAgvH2dIF+pk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=c1Un9/rkT4lRQP1K6PQSlJ78EJMaM8CQtwfepbiEHIh7+qHayLQstdKgkkfaJKV1Q
	 njYvAIijL2ksVg1ALYWZpAuESyMY0wvvHMsHBLvAAi5VjoKREBEhyHbEnxW/aUWjPz
	 KOpfmEufJqw3cE7O7DaByjVaCYlm6sG7bkcwOuv8I17zcS3fdZ3w/5ojhfqroJX55J
	 ngdx2uhf8lw53pKP3oNIxigvPwc5PyRZLtOnrH76fz9l2ge/uTt+32fAhaUjf3mVpc
	 WCMDhUaB9JHpqN3/1pVl/3DOriHGsLRrOigU9c9ycCmUheZ3ui8BtKVGBilA7gEUmn
	 BSBlpa79gjNgw==
From: Sasha Levin <sashal@kernel.org>
To: Mahmoud Nagy Adam <mngyadam@amazon.de>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Sasha Levin <sashal@kernel.org>,
	stable@vger.kernel.org,
	patches@lists.linux.dev,
	Mingzhe Zou <mingzhe.zou@easystack.cn>,
	Coly Li <colyli@fnnas.com>,
	Jens Axboe <axboe@kernel.dk>,
	nagy@khwaternagy.com
Subject: Re: [PATCH 6.1 431/969] bcache: fix uninitialized closure object
Date: Tue,  2 Jun 2026 14:21:29 -0400
Message-ID: <20260602180900.bcache-closure-reply@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <lrkyqqzmq17xb.fsf@dev-dsk-mngyadam-1c-cb3f7548.eu-west-1.amazon.com>
References: <20260530160300.485627683@linuxfoundation.org> <20260530160312.161639627@linuxfoundation.org> <lrkyqqzmq17xb.fsf@dev-dsk-mngyadam-1c-cb3f7548.eu-west-1.amazon.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Sun, Jun 01, 2026 at 07:34:24PM +0200, Mahmoud Nagy Adam wrote:
> This fix (20a8e451ec1c "bcache: fix uninitialized closure object") is
> missing from 6.6 through 7.0.

Now queued from mainline (20a8e451ec1c) to 7.0.y, 6.18.y, 6.12.y and
6.6.y.

Thanks,
Sasha

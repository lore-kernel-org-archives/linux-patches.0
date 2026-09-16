Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0627940A937;
	Wed, 16 Sep 2026 19:29:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789586958; cv=none; b=hmLEKTevjOkxo0JBAiynM1MMOJR3UPoIwE7J0n1PPYFgZqTKUbD2sTYi5GrCX/O30GgL987VCT8JlTo+gZOTdsPeDNoUVroMbXreGq6fcxozgGBdPfUYKKpAqIlyO4aFnCR0m7pQhSYJ9voOAC8F7Eyy/WtehZSkWVdD2j5xl7Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789586958; c=relaxed/simple;
	bh=VuZRzl7I15iDzvq2bDXSDp33zay/rAx3HdbFL0b6gOs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nMAMbr5CZBFL9N+v49GBTuNFFgKrf39Fa4BAwVPZIbNM3zg28rPgO8ve0h3FeBJznzMHRNfKZUQ210OTNLRuWEFCLbRibDdJq6h25KhlzogalIrNy1hiagystNNX0QIMVVkwyaJV9EVMeqzcPUzTZk0xAoaxUy3Ub+YTbUMGrzU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=EU7hvZdZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="EU7hvZdZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A5731F000FF;
	Wed, 16 Sep 2026 19:28:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789586928;
	bh=A0w6PSIVohnwiEYwTvqnu+7Pf2KcW4YBhQCEoSF/cX0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EU7hvZdZHyYuKWA3TvKm4uKXr//YF1ddrgtLW1zTj9l8spxwmzcR6YLqEJDAGiCV6
	 +eITQ0Zf0ZcJ7j1Ra525zLevP/qEho/QZ2DzhlPhiSdo75B/iviOQECW46vXB20a6i
	 BPfwRQGKHCsX+uLvnzVastp4wiv3LIoem39Vlr/evRhG7y6NgvkkyFxbxK7L4aiyn8
	 7LUKlEbQNaW2F0koisyUfRdf6wK7vD97HryAg4F3z7uPfG64kvn/VN7DXXcEEqj59g
	 zpDIywxGaGYZUZo7mBHIqVSd18Auqqd769Ep2tPz1gnyT1Hc9q4kvqcYxPEu/scWWE
	 RtOA6RTy1/ikA==
From: Sasha Levin <sashal@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	stable@vger.kernel.org
Cc: Sasha Levin <sashal@kernel.org>,
	patches@lists.linux.dev,
	sashiko-bot <sashiko-bot@kernel.org>,
	Ian Rogers <irogers@google.com>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Subject: Re: [PATCH 6.12 1141/1376] perf dso: Use stored fd error instead of stale errno in file_read() and file_size()
Date: Wed, 16 Sep 2026 15:28:08 -0400
Message-ID: <daily-reply-20260916-0018-re-perf-dso-errno@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <c0d91f0b-f392-42d1-b96e-86b5bacced74@oracle.com>
References: <c0d91f0b-f392-42d1-b96e-86b5bacced74@oracle.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

> Upstream prerequisite 1a5f9334a45a6b0c1cd7341cc72a3b87adad1d27
> normalizes this failure to a standard negative errno. Maybe we should be 
>   adding the 6.12-equivalent fd = -EIO adaptation before retaining this 
> patch.

1a5f9334a45a ("perf dso: Set standard errno on decompression failure")
patches dso__get_filename(), which does not exist below v7.0. It arrives with
069e603d8248 ("perf tools: Get debug info of DSO properly"), so there is
nothing to backport on 6.12, 6.6, 6.1, 5.15 or 5.10.

What is left is a hand written fd = -EIO per tree, which is not a backport of
anything, so I am leaving the queued patch alone.

-- 
Thanks,
Sasha

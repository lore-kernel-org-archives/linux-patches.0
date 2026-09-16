Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC22E41BA60;
	Wed, 16 Sep 2026 19:28:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789586935; cv=none; b=WMQzSWXUqx7vZ6l7VbtBRsQaeo1Xyri7zaB1hy7VWzSx9GXUelCMVkVqwz3p7/h7M/WuVoZz+r/p7wc8x07w1k2AXo4oDVMkXlIlrrz/R1njo4cZoiFBk5NIJ+k9EyPR7XsGxizgyI220WkoPhAymDZNuYiUomjeU2V8OklzQzw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789586935; c=relaxed/simple;
	bh=4AWKjFWINCurGI0yN+RPV54KzhC24hvqaOhJXBm0Y3s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iRPjHbpNt9qWcfKNnnUIuJRPNQOedBPDcc4LFcsFhx8QBtUVlDZ1giH+xnEgkWWqPyZXUUK6uugHQMXTXWYjYOGUblMTeSqT4Ef7L6vdMUL7azwANBlfihg58u5E+hC5YBdTeR5Htudd96QW6FSH3HWBK0pNo79q4H1nNIIxkmM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=M/fiM7y8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="M/fiM7y8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBC911F0089E;
	Wed, 16 Sep 2026 19:28:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789586911;
	bh=I9z4fPxJhYE4FJxI1sDYlYsY7tZhffPCF339rfMCRk8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=M/fiM7y8RE52UBw3LWTe3o7HLMIcuttvk9q8P2UrorFaajPMyZZ0U0cZuVoBnod+I
	 rOd9Alp4nFl2Lqsb15d3NOFli6Yc4L7+IEBpbSyRQ//VnMfnrBURzm0aaaN6jKPR6H
	 zTMwoloNBYUlLwMnNhRi2PfqmCAqKS/rXeonbeGOlzbSG8dNNOaUfoRhqz58pjTtY3
	 9veIs7vdZBgY8yZjYUOojfUadT1evNeqZlTlagdvmaQ2qyZHQStxhjgIX8DuHihsKh
	 UJUcPN5OGbPhwhjdsrshpHLL2oD7+sOfYcM6vkNDJKmO0RPHTrxUJrlw8pxNLIdyWx
	 t75zJkf2IUrzA==
From: Sasha Levin <sashal@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	stable@vger.kernel.org
Cc: Sasha Levin <sashal@kernel.org>,
	patches@lists.linux.dev,
	Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Vegard Nossum <vegard.nossum@oracle.com>,
	Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Subject: Re: [PATCH 6.12 0766/1376] arm64: dts: qcom: sc8180x: Fix the PCIe iommu-map entries
Date: Wed, 16 Sep 2026 15:27:56 -0400
Message-ID: <daily-reply-20260916-0006-re-qcom-pcie-iommu-map@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cc43fb43-b6cd-4d60-b077-5fdf7918cf8a@oracle.com>
References: <cc43fb43-b6cd-4d60-b077-5fdf7918cf8a@oracle.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

> Upstream has the variable-cell parser and its API preparation series,
> including ccb2fd725d411265df8f7ce12a66c226b16014e6. That broad series is
> absent here.

Agreed, and Konrad asked for the whole family to come out of every tree that
lacks ccb2fd725d41 ("of: Respect #{iommu,msi}-cells in maps").

Reverted across 6.18, 6.12, 6.6 and 6.1, 35 commits in total. 7.2 has the
parser, so it keeps them. The msi-map siblings stay as they are.

-- 
Thanks,
Sasha

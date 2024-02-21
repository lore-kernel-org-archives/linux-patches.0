Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3CC77E571;
	Wed, 21 Feb 2024 14:20:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708525216; cv=none; b=joMuSWf52ngxoDUTwzdV7q/3v27Cq8y+kLddRoSYkhnwr/j6FYw8ct51upyXaDi5m7ou9nDUcqn4273hQ+NBXw0QoaS4qD4GCzVN3kXbadzCI5/hcSDOMsaj6En9udbuNWe/UN1qTkQevHMrCc7pgv3XgtxP60JANr+vef7nBW4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708525216; c=relaxed/simple;
	bh=9UEBuLu684B587+I37NtTVbbsGwLa+rqVokwU7ndNxQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qXsly0OHwrMd6ug1AVLI5qomixOUOZuIq/uXVCBWc3OpCAsPRkTslb4Zp9c9B2Om7v6DBPtUaAsU6ZeV9BJ/ZbTctp6ks8DAJ/29wJ9h+BZ0+8EavgsZLG4MtbA+XJvcNpM1WYCBnyF0YV9tqRUtXwfABtJpsj66w7+P9EsmHfg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=c1uEy7Wo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="c1uEy7Wo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7885AC433C7;
	Wed, 21 Feb 2024 14:20:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708525216;
	bh=9UEBuLu684B587+I37NtTVbbsGwLa+rqVokwU7ndNxQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=c1uEy7WoS39ev0B52u8l4BlCrnWkU65Fd96qQj05300YGO3z0/AcUzTfCx9PWXdfq
	 y89o5j/gii/sad5QtouCKTDFAy7qySDiDCponaIGSsb0CvLeb4M2BnIXjp5Hi25JVh
	 IZ0rkbppHmZ1Nn/IfzDdJnA42eejjezQ5dCo9pFU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrii Nakryiko <andrii@kernel.org>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 092/267] selftests/bpf: satisfy compiler by having explicit return in btf test
Date: Wed, 21 Feb 2024 14:07:13 +0100
Message-ID: <20240221125942.843244133@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221125940.058369148@linuxfoundation.org>
References: <20240221125940.058369148@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andrii Nakryiko <andrii@kernel.org>

[ Upstream commit f4c7e887324f5776eef6e6e47a90e0ac8058a7a8 ]

Some compilers complain about get_pprint_mapv_size() not returning value
in some code paths. Fix with explicit return.

Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Link: https://lore.kernel.org/r/20231102033759.2541186-3-andrii@kernel.org
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/bpf/test_btf.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/testing/selftests/bpf/test_btf.c b/tools/testing/selftests/bpf/test_btf.c
index f641eb292a88..a821ff121e03 100644
--- a/tools/testing/selftests/bpf/test_btf.c
+++ b/tools/testing/selftests/bpf/test_btf.c
@@ -4663,6 +4663,7 @@ static size_t get_pprint_mapv_size(enum pprint_mapv_kind_t mapv_kind)
 #endif
 
 	assert(0);
+	return 0;
 }
 
 static void set_pprint_mapv(enum pprint_mapv_kind_t mapv_kind,
-- 
2.43.0




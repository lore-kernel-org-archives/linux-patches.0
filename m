Received: from szxga04-in.huawei.com (szxga04-in.huawei.com [45.249.212.190])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 092A81A5BA9
	for <patches@lists.linux.dev>; Thu, 10 Apr 2025 01:23:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.190
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744248207; cv=none; b=EJX/B8Fk3Nau6/QtLnMhYfHeleLGgPIgnhtdpwP+zg8uquraxnvyE27nt4W4mA7TuGOBenUVO4notG9dy4IUD8g8+17JCUEX705EPIHOJMRigZeOBzSO3IXrtnWkwJhnUV6HAeIqrqp63p85rCqFiizQkwGcUtXwWphdBWXh2zw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744248207; c=relaxed/simple;
	bh=pOZVrMfrWZwXxblXIy3b2k9R+4+tJ+rkgl/l0X+e4w8=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=jfZibAioc7QCEMmNUBTnHp/i/HJq7WbgEu/lszHFJRFuV8Ww/doWbROyRFYxJhbvXKJum/GCvYJSLSwkc4wOR8Y/LRlS/bnWGEMdCayau9UyLLdtT0U4VO2+hJKrVF8xFRBxucl0D1iWCuh3s4BsXLyYrhNqDAgeyQIfdLXteSk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.190
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.88.214])
	by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4ZY24w07RZz2TSHv;
	Thu, 10 Apr 2025 09:18:24 +0800 (CST)
Received: from kwepemo200002.china.huawei.com (unknown [7.202.195.209])
	by mail.maildlp.com (Postfix) with ESMTPS id 114B81A016C;
	Thu, 10 Apr 2025 09:23:22 +0800 (CST)
Received: from huawei.com (10.175.124.71) by kwepemo200002.china.huawei.com
 (7.202.195.209) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Thu, 10 Apr
 2025 09:23:20 +0800
From: Jinjiang Tu <tujinjiang@huawei.com>
To: <gregkh@linuxfoundation.org>, <riel@surriel.com>, <mingo@kernel.org>
CC: <dave.hansen@linux.intel.com>, <luto@kernel.org>,
	<mathieu.desnoyers@efficios.com>, <oliver.sang@intel.com>,
	<patches@lists.linux.dev>, <peterz@infradead.org>, <sashal@kernel.org>,
	<stable@vger.kernel.org>, <wangkefeng.wang@huawei.com>,
	<tujinjiang@huawei.com>
Subject: Re: [PATCH 6.6 046/152] x86/mm/tlb: Only trim the mm_cpumask once a second
Date: Thu, 10 Apr 2025 09:13:29 +0800
Message-ID: <20250410011329.2597888-1-tujinjiang@huawei.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250219082551.866842270@linuxfoundation.org>
References: <20250219082551.866842270@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 kwepemo200002.china.huawei.com (7.202.195.209)

Hi,

I noticed commit 6db2526c1d69 ("x86/mm/tlb: Only trim the mm_cpumask once a second")
is aimed to fix performance regression introduced by commit 209954cbc7d0
("x86/mm/tlb: Update mm_cpumask lazily")

But commit 209954cbc7d0 isn't merged into stable 6.6, it seems merely
merging commit 6db2526c1d69 into stable 6.6 is meaningless.

Thanks.


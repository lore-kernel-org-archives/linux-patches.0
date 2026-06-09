Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 669B3282F0A;
	Tue,  9 Jun 2026 00:52:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780966340; cv=none; b=QryesBsHYY4SofvY8Wd1KDyzlSg4leyJu2GFvAH1roZrwiL1wNEfByAK0qy4aGCid62UBCmA952yXQR6+vxpNupcvjg3Jv/07Pe3OybTZ6HC92vRKa4DC90UrQEtNXAmSWYkspxRF7NbDFgd4W8Hn5gLqYv8Vq0kAN6KkOoK5Jc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780966340; c=relaxed/simple;
	bh=N6BzSSb+OgMfdk97YJef7V8jWS7EXnX+s7PFvYz+1lA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lgkhANZLvLWwGVTiQMCNYwz09maG3meOZ8J7Ru4gGVi/lPm9bMwZB1DNG+7aAKmjGNlueOfE9WAxJqMoBRYPr+BdqXNSw4eVzAnb8ZwwT41ShYkfhjfUWzXwBObqNlV/ziamCqiUdpKo4VPVGNVjxZ5wmm5o9T5cZZVXfdXSmac=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RZYMpwZQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RZYMpwZQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB7FA1F0089A;
	Tue,  9 Jun 2026 00:52:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780966339;
	bh=N6BzSSb+OgMfdk97YJef7V8jWS7EXnX+s7PFvYz+1lA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RZYMpwZQ2U5mkNkk631MTiG6LR+IUelwqNf1hcraIihb1hh7GhL2uUlgpbRRLdMGq
	 ugItmKgP5LMJgQsiz/LtxstXQZrugXqCM5ukIFo6CuxypHkVLACpBHyq9bR+/NLiPO
	 KFGOn4oQRPj1OR2tyrIzXE2TDswPcQeMlFvUEK7xLRnzE14l+gAXvzeaVtNcuFHfop
	 Qwc3o+q30P+IlMq7smZh7V7cTO7F32YkcZi4ZFfbVuIsRy7Ut/IAH8rhZCK3WhanJe
	 ibmywaFo66n7b8LuZug26AGffay9TKvefXURYfTGFFODtpqWCSstpjMmDGPlAJu0K4
	 297rjsEvfvzaA==
From: Sasha Levin <sashal@kernel.org>
To: gregkh@linuxfoundation.org,
	stable@vger.kernel.org,
	linux@roeck-us.net
Cc: Sasha Levin <sashal@kernel.org>,
	patches@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	jdelvare@suse.com,
	atull@opensource.altera.com,
	broonie@kernel.org,
	linux-hwmon@vger.kernel.org,
	psanman@juniper.net,
	Fang Wang <32840572@qq.com>
Subject: Re: [PATCH 6.6.y] hwmon: (pmbus/core) Protect regulator operations with mutex
Date: Mon,  8 Jun 2026 20:51:56 -0400
Message-ID: <20260608-stable-reply-0010@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <tencent_53D6CAB7A20BCE168EA9DF22F0E78EF14509@qq.com>
References: <tencent_53D6CAB7A20BCE168EA9DF22F0E78EF14509@qq.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

> [PATCH 6.6.y] hwmon: (pmbus/core) Protect regulator operations with mutex

Queued for 6.6, thanks.

--
Thanks,
Sasha

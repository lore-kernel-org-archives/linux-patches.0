Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2980D3A1A3B;
	Mon, 27 Jul 2026 22:19:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785190790; cv=none; b=rjtupTyQxUJwDz92adwRKZjxuk9kBnOeJeWtJ0Jg3+hbztgGwOa83pXoQE+AOLG02jT/n/q1Yi+m5KeXI/AUv/8WPRlLWqmTl61uGkWImjWJqlbMXZ++WJAobivLBtsSwanCUZ2xdgukXCS+rZRB3oao95I6bholQP59G1Y/X5A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785190790; c=relaxed/simple;
	bh=Yass3Fmm4O9bciDqP18v0jqXnJMo7fTQ77S+aLMluQk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Eno/v0boAuhQO6aLKzuE4Au775ygz7j6rLzSjPWhsg1FwfoXnKrUMcysoX6zoNmMEVQPCYq3VYQnqX9AoISKwKEa/jhcdUFZCAKOT04c+o/sioj2nn1V3N3x5HXPivdscrW+XlzTXRVsCtFtGgLR6kQCFf4y2WthEkxSxFfuGTU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=l0DL/EG0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="l0DL/EG0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9D8F1F00A3D;
	Mon, 27 Jul 2026 22:19:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785190788;
	bh=Geb3MiTGQ+/chuE/KocCnM1zMbhGdGLPGqSWzDn8+d0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=l0DL/EG0MrH0ZPytUrW0CnNxWHgzEkVH8AUArOHddguYI6Fkus/KWgBZvRaAuBp36
	 LK0jqxzCVaUNAwP5vOAqOnzWTKTfW49eLuRQUQ6gdOv7emR2milz+lMhIYo/5cVpOb
	 Go6BSl2lcrrNSNr1i+272m1cEnbro06DJd8I6njINM7dlRjktUm79CHtXFxZd/bAML
	 qnYlqMCfaB6+B48nDaT8NH9WKPLTQjbBz79XBA2Te3G+P9ywA+6sLaSUf5RkLxROer
	 Vt7qE/G8NPP0Rs1ioajRq1SzNBsoCUPK2bu0ZbPwh9FlFKll2erTuzUeZyRAWPlaG2
	 0I0dDfYzoDpjQ==
From: Sasha Levin <sashal@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	stable@vger.kernel.org
Cc: Sasha Levin <sashal@kernel.org>,
	patches@lists.linux.dev,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	vegard.nossum@oracle.com,
	Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Subject: Re: [PATCH 6.12 1139/1276] iio: pressure: Remove redundant pm_runtime_mark_last_busy() calls
Date: Mon, 27 Jul 2026 18:19:35 -0400
Message-ID: <20260727202413.stable-0002@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <5e26bed9-8f32-4193-a2fd-49db35b9ddbc@oracle.com>
References: <5e26bed9-8f32-4193-a2fd-49db35b9ddbc@oracle.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Sun, Jul 26, 2026 at 08:55:37PM +0530, Harshit Mogalapalli wrote:
>Looks like we already merged it so a revert and redo ?

Yes - v6.12.97 went out before I got to it, so dropping is no longer an
option and a revert on top is the only way back.

Could you (or Sakari/Jonathan) send a [PATCH 6.12.y] doing that? The pair
can then be redone properly later on top of b3db492e8335 ("PM: runtime:
Mark last busy stamp in pm_runtime_put_autosuspend()") if anyone wants
the cleanup back on 6.12.

-- 
Thanks,
Sasha

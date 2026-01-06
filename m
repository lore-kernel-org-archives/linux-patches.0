Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3871427FB26;
	Tue,  6 Jan 2026 17:45:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767721513; cv=none; b=Jw8gsLm4PcAk4hZzuCqvkut3hktBvMxcdtRYPZno3RwFKh591YVuyYmnyIuBvPwr7Ky0jbORFFVvZtRepF08MlIlGHIGGKfTwrRpDHxQurAl54t/pBmJLF4bht3Q9cYCfPsXGwwJ13grIBXFPblw3xqj2OgH/Gk6db60VS9vCU4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767721513; c=relaxed/simple;
	bh=FktTW61ZP3DtHUm/fr41Jv/IQScDnlgvAFIZHIspcHY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IMvh3pTwKm/GYSQ95K331LQu6hPuVITuzr5KlHK3cmFWvpNgHVMbkPO1MnQLyVnlKGesYOMLHek9zIYhGLL+cuUADAp3j4g4e10sQxnMJ40hb0CgnRG1Jsts7qkQENcUnoKdYAsleRjpXx+vbqA7+nJhIpFHb/riZdaWFZ/H8uo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iRC8S7BC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iRC8S7BC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8254EC116C6;
	Tue,  6 Jan 2026 17:45:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767721513;
	bh=FktTW61ZP3DtHUm/fr41Jv/IQScDnlgvAFIZHIspcHY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iRC8S7BCeoba4hSVY/TIIu5nLWq6auyzeEPbdrShjGveRPEvmusNhGVDZNpuOJxBP
	 7g3AoSc0wWBEvpBXFttM9iuO69AR1ty5acFNEyTWaGaRmWob37A92VfVsYN+eUYo+y
	 zieFYtAH/w0lsFv8Mu3eskV4rTwkGPvthp36hghk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Hildenbrand <david@redhat.com>,
	"Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
	Christophe Leroy <christophe.leroy@csgroup.eu>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Nicholas Piggin <npiggin@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 557/567] powerpc/pseries/cmm: adjust BALLOON_MIGRATE when migrating pages
Date: Tue,  6 Jan 2026 18:05:39 +0100
Message-ID: <20260106170512.024809947@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260106170451.332875001@linuxfoundation.org>
References: <20260106170451.332875001@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: David Hildenbrand <david@redhat.com>

[ Upstream commit 0da2ba35c0d532ca0fe7af698b17d74c4d084b9a ]

Let's properly adjust BALLOON_MIGRATE like the other drivers.

Note that the INFLATE/DEFLATE events are triggered from the core when
enqueueing/dequeueing pages.

This was found by code inspection.

Link: https://lkml.kernel.org/r/20251021100606.148294-3-david@redhat.com
Fixes: fe030c9b85e6 ("powerpc/pseries/cmm: Implement balloon compaction")
Signed-off-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: Madhavan Srinivasan <maddy@linux.ibm.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/powerpc/platforms/pseries/cmm.c |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/powerpc/platforms/pseries/cmm.c
+++ b/arch/powerpc/platforms/pseries/cmm.c
@@ -532,6 +532,7 @@ static int cmm_migratepage(struct balloo
 
 	spin_lock_irqsave(&b_dev_info->pages_lock, flags);
 	balloon_page_insert(b_dev_info, newpage);
+	__count_vm_event(BALLOON_MIGRATE);
 	b_dev_info->isolated_pages--;
 	spin_unlock_irqrestore(&b_dev_info->pages_lock, flags);
 



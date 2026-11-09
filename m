Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794247335;
	b=qGvU7iad9OmnDE4eEQjt4y7VzG2PX00XO5CEMGoGEOPHMrf05rCesGYhDlUcwjoMs6Bk
	 kO092u4RlMWQnsBVr899lxxJhG7Rl70RyO0edQsknHwA8jB1VSxGgNkJjUj8RPNC9C0zz
	 ddc5ZAyaEvnKYDUAy5hrWVkRAulf4ZyTx7rD0EbK7aM7f0WvIDS68OxlJZgjBB1F9j5+n
	 8SibCAg8kG1Z68kkXBGL4mjaLchlqsMKk3I95pbxlZ24NeJiWs5fwyXN4+uz7zqbEbRe1
	 hY/emeBVq8GfOdHVBrZOO10lhkL0yHDdwzBZvHxNfGcKHswGlrFsO+RgK24Cg3lFEsQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794247335;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=uPTA1LqxLPsdj63bEWhpxMh5vxPoN5OnbFvNPNCNriM=;
	b=XYTzPJ0J278evKIJlCbvJX+wXUA8YSWLTSgFeRFP1Z0zRePHpBFdeZKQwpZXNSfBVBgU
	 W8s2NaOICoi5HbfKeznsn8tejfg6qToxclRKSZUa2MOdilM4P2JgRvLQcXbjXlnZ7gW46
	 YnCVIxC2LEjZpzGcUr5RgExiWw1Kr2oHcvno0AER6KM/5TA1IOhRCT2NU2Sn9lsqaTmfb
	 pTJbuqpPufZNatwGAwN25dflHQtGfFuXnkiwFupR/AJiFA/QHrIv/IxGoZ5It3YCiQBl0
	 72k+knflBITHfxeYjgZpfFldwPrXtZXcK1PgtNlEPWzDm0vP4wwrR7bDEpNq0qNDjbw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=epZT6IgT;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A612B606A31C;
	Mon,  9 Nov 2026 18:02:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=epZT6IgT
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF7AF1F0089F;
	Mon,  9 Nov 2026 18:02:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794247335;
	bh=uPTA1LqxLPsdj63bEWhpxMh5vxPoN5OnbFvNPNCNriM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=epZT6IgTbivLD8WNqoW8r+IaQ2/9aX416G+b1y1vO3V/52uWbicRvHZYY7QSIAM67
	 WK3Tjb6BGyYIiN1aUgVOX9GN3Bex6fSkl44ctms8+O/fclXs6J3AKr1GmdlDxGyKfV
	 DI23funhGe9hVsTvbY691+UY1PLdGMyJDt3ZvkJU7ObtsSpIbC8hVTT3cey8IArgGY
	 +eJLGVmgHXjLn0aTaKxZ4PqR+UtT9Eh4KQ9gTZtBAdPHIwFsV4ZtfO27awLnn9LWEW
	 gOryJNEy3qpHw9BBPkotTQLcOmoM/sw74aFcm3xWutLQrnKw8DKZPMOEtdVzTA2Ls7
	 j9sBs8ISVrtrQ==
From: Sasha Levin <sashal@kernel.org>
To: Ramon Meireles da Silva <ramon.meireles32@gmail.com>
Cc: Sasha Levin <sashal@kernel.org>,
	gregkh@linuxfoundation.org,
	stable@vger.kernel.org,
	lyude@redhat.com,
	airlied@redhat.com,
	patches@lists.linux.dev
Subject: Re: [PATCH 7.3 0013/1257] drm/nouveau/gsp/r570: Set GcOff = 0 in fbsr
Date: Mon,  9 Nov 2026 13:02:11 -0500
Message-ID: <20261109130000.drm-nouveau-gcoff-drop@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <CAN-h+BLrxhQv_Juva1P-es9m5Yk0Tv3OsxD_KM_nXxz4YiHs=g@mail.gmail.com>
References: <CAN-h+BLrxhQv_Juva1P-es9m5Yk0Tv3OsxD_KM_nXxz4YiHs=g@mail.gmail.com>
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Mon, Nov 09, 2026 at 12:22:51PM -0300, Ramon Meireles da Silva wrote:
> Please do not merge this patch into stable 7.3.

Dropped from the 7.3 queue. The same change is already in v7.3 as
12f6eff11ccf9, and v7.3 then re-enabled GcOff with adb87c20081e5
("drm/nouveau/gsp/r570: Enable Gcoff in fbsr again"), so this copy would have
reverted that.

Thanks for the report.

-- 
Thanks,
Sasha

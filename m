Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3A9E57ED9F;
	Thu, 15 Oct 2026 19:36:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792092995; cv=none; b=OHrBVpVMEJwkrhK5/VHxXWvbOujue/KlALvPDbr2Ubn13VkKOZ1cBkpfNWdP+WRmTEH7NZEJ9MP2VaoEXpzohAETMM+3orGPlQgXYpMgQJV1mluAExPS63nyIlvhvtfHN0wmdCCDBxA+aNZIBbG7c6ZhA/CVMrYHOJQp1tkkKJ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792092995; c=relaxed/simple;
	bh=XkvxgVoEVGYFMWh+hbP84m/M1nGF5fNrFzLWVizBzWs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R2lKNR7iJSk6k23Dg6bMGBY4I4SSNBWMkGRAOVNCfTMeL6zjTsB2jWAdE/vw6QnH74YS+zPeCmEwf4Ulo9cuMr9QRNojoye7gsKpiqcfH2FURNkryzEtKEmBVmEFno1RtOJKjDg5NYmh+SXBK1JuwLTlnJqfJpH1b+pJ75lEBzI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=iVs9iVFE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iVs9iVFE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8319B1F000C5;
	Thu, 15 Oct 2026 19:36:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792092993;
	bh=wSKMutwZ6UIgbi6zHFxoHrLkQZ3IHqj0Nrnh6JlgOJs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iVs9iVFEEcIAsZJN1YUtF5jjW9kn8pJWWWEJKcXYozLDkV5zU+3BSubcMu2L3jXWY
	 Zuqpvj0c/wJcf2o1M53ocHy3DiMHjlZ1hIPn4Oi9/G3ixVbpHcuptBsMAowH+kOpDC
	 +TIf1wlflV7YMfV2wg7m/nqZe3j6jHhB5+wT81dypJSlITNHTfQyBPZ+2AmsDq492a
	 FpNRw4Qa3ghp6WdmtZKZ2gufOghh5z4jEznDEZT08DnkSTErYMdqwFrkqHYTQogll5
	 9+FijvDhfIXaLDd9T/z1tVyMkX8sO0hPxCknNnYubW8TY+NrOFJAf3XlEljGi68W5Z
	 x5GJc25bVqZTw==
From: Sasha Levin <sashal@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	stable@vger.kernel.org
Cc: Sasha Levin <sashal@kernel.org>,
	patches@lists.linux.dev,
	Aaron Ma <aaron.ma@canonical.com>,
	Felix Fietkau <nbd@nbd.name>,
	Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Subject: Re: [PATCH 6.12 465/497] wifi: mt76: mt7925: restore the legacy BSS after MLO teardown
Date: Thu, 15 Oct 2026 15:35:53 -0400
Message-ID: <2026-10-15-1-daily-reply-0010-mt76-connac-inactive-bss-prereq@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cb60573d-858e-4a86-ab7e-05bbce6227d2@oracle.com>
References: <cb60573d-858e-4a86-ab7e-05bbce6227d2@oracle.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

> recreation proceed.  04222f980301 ("wifi: mt76: connac: tolerate
> inactive BSS deactivation") supplies the required tolerance.
>
> I think we need to queue this prereq first before this patch. Thoughts ?

Queued the prereq for 6.18 and 6.12, thanks.

-- 
Thanks,
Sasha

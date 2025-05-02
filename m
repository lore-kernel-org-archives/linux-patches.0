Received: from mail-ej1-f50.google.com (mail-ej1-f50.google.com [209.85.218.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8111738F91
	for <patches@lists.linux.dev>; Fri,  2 May 2025 04:50:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746161402; cv=none; b=ew0rR1Z6sPAYiF6NcKmCYTlkCs5po9Rj467XNhsxOjjndUfW8/LsbEvTnJwoS69+JHdvpoRSh2oqfYBXFpIBCAHQ6F+zOfMemaHi6RqmOMj4fAklZgaqzN/8OM/WrBp+tK1nrbYg30ZeE/tbOdlgzmQ93f/YmNiAwQEYKFbk+eE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746161402; c=relaxed/simple;
	bh=t7GUHBJG2OfqdZA+Y8t+F1Mmh6ETegG4Nbvqo05qsKE=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=jYp83gOBzMu6Yo9YQnPsAaRs20OT5Nb8akCG7IRtGyaTkObHYkgkb5VKGgbF2jaNwjNyg1uQPxBsPLy6TzBZNPA/hxYa9CtPupOIARvrTud3zEGr+/ZbcpuuTAziO2M8O0koyqqnE6QBuRDdU/cEkEk1uDYLbvexk7kFXa+l0FE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=starlabs.sg; spf=pass smtp.mailfrom=starlabs.sg; dkim=pass (2048-bit key) header.d=starlabs-sg.20230601.gappssmtp.com header.i=@starlabs-sg.20230601.gappssmtp.com header.b=AU8jqrG1; arc=none smtp.client-ip=209.85.218.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=starlabs.sg
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=starlabs.sg
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=starlabs-sg.20230601.gappssmtp.com header.i=@starlabs-sg.20230601.gappssmtp.com header.b="AU8jqrG1"
Received: by mail-ej1-f50.google.com with SMTP id a640c23a62f3a-acbb85ce788so364298466b.3
        for <patches@lists.linux.dev>; Thu, 01 May 2025 21:50:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=starlabs-sg.20230601.gappssmtp.com; s=20230601; t=1746161399; x=1746766199; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=t7GUHBJG2OfqdZA+Y8t+F1Mmh6ETegG4Nbvqo05qsKE=;
        b=AU8jqrG1kfvhdsRh60TdrjsMnSw6fmO0/NonLkJvAhxG50tsxefmhJsBL/BxSiwYvc
         dyewO+rGxrpggFyydaswjaM7ohLDptMtEcAILUMiHCcFkQelBKJD0xkVtebKTI5fu0Pv
         GDcrpyW/GxqE0QqITMFp3Cg74iZ9FQ2CSxTr+4WkIRy137FTkZ8Rno1e0IPyzpJ79CHS
         +vQPDsFrK314OhziDsGbEkXhixRJr9UauE273WRDlzvCMMd1dS8nZuKgb5dmbHTw1ZYs
         l0mg5NMLVhvki4aQFTZikj2iY1TvLToi0PRrxT3/X94AzrjW2+J3hv1dx29a+4I0HqZA
         K8qg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746161399; x=1746766199;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=t7GUHBJG2OfqdZA+Y8t+F1Mmh6ETegG4Nbvqo05qsKE=;
        b=NZvJV4VS3Sr7EYf7PHvL7ecmJsd5fCy69ts9qrdok1fOPN2ZMdBnb/bwU9oDW9lBYB
         RiAPtXe4Tlc1SnIzSBkw8zPV8sTLUsYmS7ds4n181gfGnCm3EFOPeF5MYMSwDx9c0s6/
         /VmKdfVudWj+aaRTX0F6ZgQjS0bYWRUOADQ7D+gsIeLrgqNcj9JilDks5HztJdDVui31
         HyL127ar2MsJoWNZlfqKxyw6WLbZ91RP9X58/G/R3McWrrKXQX7fd7OHMd8Azyg54Sxq
         bEPj75N+ND6NNM952//gJp3628Y0PnZKq0wTnItUl0dLV1k3yIdjN195BEy9JZeECn/3
         LXUw==
X-Forwarded-Encrypted: i=1; AJvYcCX/XJTFFsKGeS3s9szwrmK2Rlp/BEN3U1bMbdsSfMM77xg8v42PIyOaCX0dqa938AR4C/sQgrMs@lists.linux.dev
X-Gm-Message-State: AOJu0YyhcrhOrI6/VUJqDB/yKL9SCwbRpOSfzu5xeNPtXWG8rrASamfc
	8Hv14R1uUndW50AuOFSqt36atiuYJwoTVg0egSe4CROWPlYUVWCbmpcfDdtbpVcC8B+5C1zIn/U
	xiFg++vm7b5mNDA3dQEw3z5EZhGvG/Cdibt4c2g==
X-Gm-Gg: ASbGncvByOHa5VOQixz18OQQVLjTp8Eye/xDV7HYw91lSQh44f18rNPvrnjIi2krA/x
	NpekthOfnhHmKiHB5iQAISfBIWGhCuUZ3TFYQJXDde5hWnTX4CkpTaV68wnAq5YILcKS61fVxQn
	xRsu68UJEV47h4ZIwUwnqK84Z0Ffv3SyVzJlw=
X-Google-Smtp-Source: AGHT+IE+hk2X2O/fVRf4sh+9f1WfxFpGg4L0tIaKr4WVhkmnqLXu1YKQY6l3x9CO9eBbemy4hHwACTh65/4bHXXCOMU=
X-Received: by 2002:a17:906:9fc5:b0:ac7:16ee:9112 with SMTP id
 a640c23a62f3a-ad17a83f6ccmr150706466b.0.1746161398503; Thu, 01 May 2025
 21:49:58 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
From: "Tai, Gerrard" <gerrard.tai@starlabs.sg>
Date: Fri, 2 May 2025 12:49:48 +0800
X-Gm-Features: ATxdqUGAhIQWCjWAh4JKMmRbPdbMypI3wXwhcpD2Y6XYiuqqWf68eUDNW4gK8uY
Message-ID: <CAHcdcOkW1D_zKh-HPsfjX-oGYhv-OwojPXVwcA=NYoO0hcCbZQ@mail.gmail.com>
Subject: net/sched: codel: Inclusion of patchset
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, patches@lists.linux.dev, 
	Cong Wang <xiyou.wangcong@gmail.com>, Simon Horman <horms@kernel.org>, 
	Jamal Hadi Salim <jhs@mojatatu.com>, Paolo Abeni <pabeni@redhat.com>, Sasha Levin <sashal@kernel.org>
Content-Type: text/plain; charset="UTF-8"

Upstream commits:
01: 5ba8b837b522d7051ef81bacf3d95383ff8edce5 ("sch_htb: make
htb_qlen_notify() idempotent")
02: df008598b3a00be02a8051fde89ca0fbc416bd55 ("sch_drr: make
drr_qlen_notify() idempotent")
03: 51eb3b65544c9efd6a1026889ee5fb5aa62da3bb ("sch_hfsc: make
hfsc_qlen_notify() idempotent")
04: 55f9eca4bfe30a15d8656f915922e8c98b7f0728 ("sch_qfq: make
qfq_qlen_notify() idempotent")
05: a7a15f39c682ac4268624da2abdb9114bdde96d5 ("sch_ets: make
est_qlen_notify() idempotent")
06: 342debc12183b51773b3345ba267e9263bdfaaef ("codel: remove
sch->q.qlen check before qdisc_tree_reduce_backlog()")

These patches are patch 01-06 of the original patchset ([1]) authored by
Cong Wang. I have omitted patches 07-11 which are selftests. This patchset
addresses a UAF vulnerability.

Originally, only the last commit (06) was picked to merge into the latest
round of stable queues 5.15,5.10,5.4. For 6.x stable branches, that sole
commit has already been merged in a previous cycle.

From my understanding, this patch depends on the previous patches to work.
Without patches 01-05 which make various classful qdiscs' qlen_notify()
idempotent, if an fq_codel's dequeue() routine empties the fq_codel qdisc,
it will be doubly deactivated - first in the parent qlen_notify and then
again in the parent dequeue. For instance, in the case of parent drr,
the double deactivation will either cause a fault on an invalid address,
or trigger a splat if list checks are compiled into the kernel. This is
also why the original unpatched code included the qlen check in the first
place.

After discussion with Greg, he has helped to temporarily drop the patch
from the 5.x queues ([2]). My suggestion is to include patches 01-06 of the
patchset, as listed above, for the 5.x queues. For the 6.x queues that have
already merged patch 06, the earlier patches 01-05 should be merged too.

I'm not too familiar with the stable patch process, so I may be completely
mistaken here.

Cheers,
Gerrard

[1]: https://lore.kernel.org/netdev/174410343500.1831514.15019771038334698036.git-patchwork-notify@kernel.org/
[2]: https://lore.kernel.org/stable/2025050131-fragrant-famine-eb32@gregkh/

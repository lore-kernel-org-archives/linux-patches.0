Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91ACD38D6A2
	for <patches@lists.linux.dev>; Tue, 18 Aug 2026 03:55:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787025357; cv=none; b=kuxizyL69bmbjC18/Kmwo766MyRnm9REQhreDWO8tb3y2/yJwbOPWrddZJNJCln66qBIBYUi1FWf2CrZ0eb5uQZ/DG/mIO+CQsXvZWBPOO5Te1JKHvYN09auTNF6sfF1JXixgEMlMKpe/Be2B8juiF5hhLE2CaR4jTa3nQFusx8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787025357; c=relaxed/simple;
	bh=mNkktjIBhFvG2qkDlcIxBp61zg27Rct3yqZtnKnK+Xg=;
	h=From:Content-Type:Mime-Version:Subject:Message-Id:Date:Cc:To; b=Lgh1EUVDncLDpeLJQMNWS/vv4xvgHpEM+kE8mydyM/5U39Wwr2mXyvqR2qN3HCjheb6BtEciuG++VYGGzOmNAekPB6TJDmsd59ap0DKkN7iOOUApmd3FnQ3wMzZzcJwP4CIwGknJ4xsyH7K2szNir/rtxZgNGvcyia0NAiS07g0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=CpcBDuKp; arc=none smtp.client-ip=209.85.214.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="CpcBDuKp"
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-2cab973140bso63179095ad.3
        for <patches@lists.linux.dev>; Mon, 17 Aug 2026 20:55:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787025356; x=1787630156; darn=lists.linux.dev;
        h=to:cc:date:message-id:subject:mime-version
         :content-transfer-encoding:content-type:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Bmnhuank32qRoTHhcSzetzlluMM3ogUWu7ffskHGsHU=;
        b=CpcBDuKpWjlAlDFxt3dhm0VWxzccrP0A3NIFG2RgbTJCoCgvH2WbDu3LJ2y+Q7WGOk
         EW5i4SwSzQXOwDLnrWXsuUCrvUXeX32aQa4nl1Zp9K6slELQcDBxTCcjlgXMELiAUpN2
         tefE1y4gy9CHcm2XtPtVkHqQd3NHjD8dX+r1uQM9OCv1LC7kjU0HP2vNL5dFEqASN4Ty
         rNoO8dTgLcSr7hPsALE4XPuNOZvWAkuC19n+5KRtjRu8ibdPial5lccTTtbIOs+IbW7+
         PRFpPVrSZtFED+8Gpzhe9GPHgXHK47gB1ZSlLUJAKcARS888C6rgqj5rPREQspXme1t3
         vkaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787025356; x=1787630156;
        h=to:cc:date:message-id:subject:mime-version
         :content-transfer-encoding:content-type:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Bmnhuank32qRoTHhcSzetzlluMM3ogUWu7ffskHGsHU=;
        b=kxLNg+Gmo0fNfvyE1RcqPOo25vz/DGABXmJ1VBKLvABN38J+WqmSBs3AvLI2q3iACl
         pkZunMphpstZYboYSaFnWC1KdsWlae2DOhlAKbQJMWtmtPfTUIzGxRCKQ1rdh4zWRSBB
         AijXALwEanlYfi2gLc/dVnjpViBsdBEKVg+xxiIX8nZbqe8jXJAbU/Nz5VeFSDhMH1wn
         0Lr15xOkNdxcxeGgqQit5eIiDUPW7AHIRFcDaEQEOn1xbVBFdwrKmYsNgLFlw8e3urH3
         0BSwZtl9/zAcGqxVRu8wi5hiQ/WwtzokJ7OeAG2EVucHSwpIj1b5bah9oYjWuigYExtE
         ZHcQ==
X-Forwarded-Encrypted: i=1; AHgh+RpfZ4e6vuoCZnW4NShMLxyk0br+0Q/ys7QK3OjvNjpd1j40k2i96OdqpU5pEysnFZ5gyORkPKwt@lists.linux.dev
X-Gm-Message-State: AOJu0YySHkM3OibK/dtOwbRzhkehI2oFB4p1KtYK0/cLXn17ZJVJTUNk
	CjWkMmVG2kk8O+3fYGakIxwmJriJpyJOaZPqmQbgWfRCqn1J/Qf+HP5v
X-Gm-Gg: AR+sD10EYCgf0fBWEzR+Ug1VgnODKMcM9JU7BX2OuwaDX8sxTzduj6rIT0bKezXiK7m
	lrA5lHEZFs36uowmnjL4oqE+3CPPfxc7Wa/1O1dy1cVU+1/gA6ubEMmum1nNyf6T5cffZfuDtKE
	NDvSgTwtirKreNSGjYDQR/yjx/n0EjfiTXlbSdFfypsj0+Bd0bLgCS30Jn4YGqYNqWL6EJ3Jmj1
	AtOvEKZv1MUShuQSqUwCZWKVIa9fEawvpgUgnRDc/OW0rpCwIn9K7oI11pFYnl0RbQZczENaC4/
	sx0UMjmowkHdqgVgyGVAZCBuMDb/Sp2cJC/y5q56sAB4TKBnvcHvvDi7j9zBtks4Gvj6wDCdD12
	EjnPZxPBzoWnf5kUyxpsOWaKnAb+d+jErN+5+EgPdp9MZ6CH9Ip7psaXgKjno6gezLuocKVXnx5
	iZos9qNkFurR6vgeGj2dFHetOgTGrbXnTbbnwaODx9yGJ7k0O/WvG1lfrWtP0FjDxhimXjM79nm
	ZuIGjPtFmY5mw==
X-Received: by 2002:a17:902:fd8f:b0:2cc:d6de:d597 with SMTP id d9443c01a7336-2d3b086d3f8mr332695585ad.7.1787025355644;
        Mon, 17 Aug 2026 20:55:55 -0700 (PDT)
Received: from smtpclient.apple ([212.87.194.239])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2d5bb496edbsm12839695ad.9.2026.08.17.20.55.41
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 17 Aug 2026 20:55:55 -0700 (PDT)
From: Linfeng Sun <linfeng.sun.dev@gmail.com>
Content-Type: text/plain;
	charset=us-ascii
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.700.51.1.1\))
Subject: Re: [PATCH 7.1 065/271] vhost_iotlb: bound map allocation in
 add_range
Message-Id: <8C74607E-84F5-46BF-BE37-7F04B62D865E@gmail.com>
Date: Tue, 18 Aug 2026 11:55:21 +0800
Cc: linfeng.sun.dev@gamil.com,
 mst@redhat.com,
 patches@lists.linux.dev,
 sashal@kernel.org,
 stable@vger.kernel.org
To: gregkh@linuxfoundation.org
X-Mailer: Apple Mail (2.3864.700.51.1.1)

Hi,
I'm not sure whether it is still possible to correct the domain of my 
email address here. For subsequent kernel commits, I have already 
requested the correction through .mailmap; the corresponding message is:
Message-ID: <20260810184837.ECC451F000E9@smtp.kernel.org>

However, as far as I understand, this does not seem to affect 7.1. If it 
is still possible to update the author information here, I would like it 
to be changed to:
Linfeng Sun <linfeng.sun.dev@gmail.com>

My edu address does not need to be corrected; only the Gmail address needs
to be updated.

I sincerely apologize for the trouble caused by my oversight, and I 
appreciate your help with this. If this cannot be changed at this stage, 
that's fine as well.

Thanks,
Linfeng Sun

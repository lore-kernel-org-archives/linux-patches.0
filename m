Received: from mail-pf1-f181.google.com (mail-pf1-f181.google.com [209.85.210.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F92C188580
	for <patches@lists.linux.dev>; Tue, 10 Jun 2025 03:48:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749527335; cv=none; b=W0i4Y8Qiwi0IOk7sQyYjjHGkuDoJQFlB+dWxS1oR1cMrQkCStjBvcvZFdXVBQw5HJQPdBsdBCCnQ1zmYHGbi+3XvNlXqwaPvATuCZZMZ0PxGvemmtO2aZ3aNeBmsMS6aDrUBNGpJKOrG3pbEc9/F2KPqbQjA1sdgPCXIQZy6zFg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749527335; c=relaxed/simple;
	bh=LfDKku90Dd3qk/Tpjpfg+vTZqQ5m61fR/4fkUTRneyg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Tb9mERT76T73hBLs1cm3pUN/s26VuTaWYrRssr8zE7RhA3FmE0Z6sYZesaxgF7zBDoDXMKEbc5WiBuaWqLAgjYBcr/QGYACiXarvZwUlwrLa8c1fopTM6uSZ9Y0VcJiWWR6O0HaPu55obNd6f/oaMTXEA7xKT9Ok5hyucH+fpsY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com; spf=pass smtp.mailfrom=bytedance.com; dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b=EdJf3meR; arc=none smtp.client-ip=209.85.210.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bytedance.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b="EdJf3meR"
Received: by mail-pf1-f181.google.com with SMTP id d2e1a72fcca58-742c46611b6so6273655b3a.1
        for <patches@lists.linux.dev>; Mon, 09 Jun 2025 20:48:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1749527333; x=1750132133; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LfDKku90Dd3qk/Tpjpfg+vTZqQ5m61fR/4fkUTRneyg=;
        b=EdJf3meRn/LwBB9b2pNwQfStRzkAw5nUt3DfcXydTgVbWn7PIQpgXe1Ui+iyRv3XLI
         zabqePl+rXd5Oy7Aowu3aMJRfMOu15aUuTMJBJo6f0VDh0g6veP7fEEPvEYTOrNxNuyo
         cp/q/7aWK3UY88IPeirPb/x+YxPmFsX8M0vPEdSvN+C/LgWLn5iNiYJkLJgagWNBxoEG
         Kc6ApPaqnOqntLNtB6886y+V9B8EqU18lUoXdmhyZz0fYwQwK7LHmPxkRrmU2Tc2Egnw
         fyTZ7flbSzhgQCqsEvvgmXN3LzkxSgWVMP6AtajDfUK7D1tSPrMUdHACPlubbe97CP2+
         y9YA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749527333; x=1750132133;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=LfDKku90Dd3qk/Tpjpfg+vTZqQ5m61fR/4fkUTRneyg=;
        b=vW6lZuuRVtc+k7izPK914Y90NPVFCtXRHGh/GuQbTQqDuUgqECsPKX6R+6ACyG4kVc
         vLRRduxE8I8kkNfDtVhfukK1LhBdd5NCnQzO+1x/vlP/iczoQzg85XEqrfFL0ucG9Zlb
         jJT0xKHht0/jFIvrAdoc5X59jckj6MoM7SrKsPBTug4f9bjfXFMnnLADwgaqLy07hzQ4
         +2fF8537p+iQNlWCAPZ7daRbGKzxNPusHum0tl9OuLoRAJI2Qd3n1ZLLqyqtTOtswkOP
         bdrPo4TlTCOnh4ocyCTEEU28auNVchT2lzt7lTmUgaaYj/wcx7kgAB9N28NhYjhxQBKQ
         1ukg==
X-Gm-Message-State: AOJu0Ywwx7FQvggPunWBHvP4/JcKo2GUHo4dfd48xnQR4YbtdcTCg2t0
	MedQe9HXLA9/rzxe0Z0jw1GWNfd06DIjHNAgJIjwe7IlZs6V7dkZ/F9BVVK9jwgsU6U=
X-Gm-Gg: ASbGnct4QV0EAOeE6HzVhw3XVDD9iD9khz3tq7U5+JyMtAfuuSyFNlkm9nfA1QDWPZt
	awCvgcA78Ty+7Hvix6K43vbiSzkkGPg2DuKOCLyPOLBliB7i+4qP4oKHBO8CQf/TOpkJFm9/JAq
	QLDxN1L57n7D6H8CWUPkf9HGB3XxzaPFeM4Z7D6d2jLkQNyBWK7HrtzQorQm5W8yai/gzffylN1
	+MPdRAHWv6eIYN7JvDjFyQT6yGKR+tH0E4gIksWgsDGeeb8wlLUOTsBMGZrKal+7niB+aGF+pV8
	Pex3y/RnygV5PmBod5WdKPIBhjqn8fk3/y0T3KrZr3CpgE9srnhOdBUe16hck33/SpdmMzccgA4
	WWLH8CfScT9/LYa5Lolc=
X-Google-Smtp-Source: AGHT+IG1ix41IRlPEDG1HenvHY+yF8PR1xemRzGkkLgVLLnz1RDwPTZbUhRrHTkZMMX4Gu1C+XxPvg==
X-Received: by 2002:a05:6a00:2343:b0:736:5664:53f3 with SMTP id d2e1a72fcca58-74827f159afmr18347886b3a.15.1749527332612;
        Mon, 09 Jun 2025 20:48:52 -0700 (PDT)
Received: from localhost.localdomain ([63.216.146.178])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7482b083b03sm6488081b3a.83.2025.06.09.20.48.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Jun 2025 20:48:51 -0700 (PDT)
From: Han Young <hanyang.tony@bytedance.com>
To: lionelcons1972@gmail.com
Cc: patches@lists.linux.dev,
	stable@vger.kernel.org,
	linux-nfs@vger.kernel.org,
	Han Young <hanyang.tony@bytedance.com>
Subject: Re: [PATCH AUTOSEL 6.1 3/9] NFSv4: Always set NLINK even if the server doesn't support it
Date: Tue, 10 Jun 2025 11:48:40 +0800
Message-ID: <20250610034840.36099-1-hanyang.tony@bytedance.com>
X-Mailer: git-send-email 2.49.0.654.g845c48a16a.dirty
In-Reply-To: <CAPJSo4XSoTNVvH8MpZWD4W50u=U4bw6YBCnNeiJZpe2LT-YNYg@mail.gmail.com>
References: <CAPJSo4XSoTNVvH8MpZWD4W50u=U4bw6YBCnNeiJZpe2LT-YNYg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Mon, 9 Jun 2025 at 09:12, Lionel Cons <lionelcons1972@gmail.com> wrote:
> How can an application then test whether a filesystem supports hard
> links, or not?

I think link will fail with EPERM on those systems. However, this patch
doesn't break existing things though, since filesystems don't support
hard links cannot be mounted by NFS (before).

Thanks.

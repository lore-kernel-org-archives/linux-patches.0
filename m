Received: from mail-pf1-f174.google.com (mail-pf1-f174.google.com [209.85.210.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89A9B36C0D6
	for <patches@lists.linux.dev>; Tue, 11 Aug 2026 21:22:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786483377; cv=none; b=VFOtHaVgjM7nz1ons+3DCVJa8/V8cT4VgkmpuPs8JOfgcaoHyeozHPujowHqkuB39wtN3E6zfLRjCQbvbgmYCf596bzaHqayhu39OumEkX92lMaaoPlxPOgeNSG/S/zN1N11S//VCtFf89pOKTLAiAj3OsdxxiVaORb3QHPd/C8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786483377; c=relaxed/simple;
	bh=XN/rifqNvJQDtxhcJX1CkOjTxm/idHUoaQKoCIcr3J0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tMEhdf7EhfOxiRpyY3YpeYXKsXDxDXxAV965HI7ivlx9CAw2Sy12xEFQ9bV+sdkitxyz1iQOdMDbE3Txa6ggA8B571XjB12g3nhnxG3IwehW8kQDacDi0yfVrGtyCJwGMoy9Yeq5DcqcmnANDVblI6qYTaIMtgmLIJTuutEwgW0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=YDg+BMXX; arc=none smtp.client-ip=209.85.210.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="YDg+BMXX"
Received: by mail-pf1-f174.google.com with SMTP id d2e1a72fcca58-84e507b079dso248900b3a.0
        for <patches@lists.linux.dev>; Tue, 11 Aug 2026 14:22:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1786483376; x=1787088176; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=duzXNp2G2UESyfsX/Nv+I5To/x8QlNagRZc9TfujvZ8=;
        b=YDg+BMXXDNxAfTn8w5QNYK8Qo8/xQ4n5VyuiaozsHxudgGlFw6bjXSm1xYexdGzU7u
         4fcOY4L+9Q2Hh/ikl5vtak5TDXNLSYCLO6/hu0Z67uXiTQ1UrfkcLIE1caaYO8F1EJ2i
         fGjKYFzJRl8Y6+rPG1U6Ah0yiWB+w3/oGn2C8cmizEiVQGv9y73m9Q7al+u2EF2ZQ8tB
         09zsJkwyDRwaIJaeB2bD9J4xJ2/5gm4UQCsmR4CI6TmIsag48IA1HqccCPu8rTfpcCjs
         kmqwp/037vpUWoB3X8sGlq/Z162YO60gvwhSWRNpmgY74TOmlSqi8R7FKVd3l3JU87gi
         DRFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786483376; x=1787088176;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=duzXNp2G2UESyfsX/Nv+I5To/x8QlNagRZc9TfujvZ8=;
        b=YuJb7gqZBj79cYHnac3mtfWjybTikvvsWFwEBQwv3WkDRaIzt/Sd8PYU5rO2gVWFF5
         hSi2g4J+gcW5RBLstE/whes2Ur4eh5R6vC6g6Cq8qPbsKGip+G5MDasRU144N963bVw0
         BB6bL/6ge5x8gpCKPwjCymt3b06R6eLpg6QRioW8qmhiobt7350kCo086Ehyuid6PrvS
         IjkW8Zu+nXIdL7SGBGg3ce9nIvFYbBJuCpyI1Vc+o5aHzC/Y6tOGZHeGIk+VcXfSf/ql
         ttoIl3SZTLAQUQGo6vdBwrMxV1IJc72e683sKSJW/a9y7DJJyHvmlWM2PIBqiAfRm26i
         cpWw==
X-Forwarded-Encrypted: i=1; AHgh+RoQxKQUc3ShbnYqsa1d2gCSJDDMwR31L2O1Yc6hN5OzBCFsuZTiVy7pFA1zNWjdF1eaopwTzbz7@lists.linux.dev
X-Gm-Message-State: AOJu0Yy42nOyJ3py5JwcnRxo47NiJIR92tT9alolfeKNG6IVKnLWh3Ml
	4cR219jWigq0ZwQ+WdWngGd6sbXvtA9NwH/gw8XlWClRMJKgoeKWIgrMKQznjL8NgQ==
X-Gm-Gg: AR+sD10NXZNbwpam3+RY65s7GvwwEoX/vVMwp1yj9dOk0P3rG3onNmJJ1/iFZbcIBa5
	SBCYC8uHFPuqVC2Z0dc+uXlLjfIU9bT/QEpRD68f1Un6yN8voIkuFDrjC6Gwko8HbjJ99XzTcWv
	Qi8iZilmfjYq1oniGR8KBX6F4jWIqbKbuLkegfFEuhf0bkBbOzZ9wCpdREsWQHhezexKPYbu7pm
	C5QZ0a2dATOQE8UDrkwd4a+XJoWkgmnAMOFcP2UrT/f+iSdeLp71d34QsMe4+YTPzrI5zjiFk30
	GD3pvrhfHotX2tGGJaboskpbzLpgOAoCIipjQjgx7cuKRMfSiIYoH7YPO7aA/zizSofv/kDRplv
	UpuPyRmPkTJXzTts62BiZ/oGwSwel/52kocJb0cQFIx5ELjT+c/igHdg1jfj6zs5yk0P9I5tV40
	CDI7oDh5scJvmz/0/9wKbWm01KuHDOl3xbsFalBn3bXbznxVdaK78YJ1H+LL5H+cumB/a7SmxzQ
	QZ3FBRkGCL4276N1+yqOiNBmFbj+Q==
X-Received: by 2002:a05:6a20:a105:b0:3c3:a168:edc3 with SMTP id adf61e73a8af0-3cc2bcbf252mr7676629637.38.1786483374995;
        Tue, 11 Aug 2026 14:22:54 -0700 (PDT)
Received: from google.com (132.200.185.35.bc.googleusercontent.com. [35.185.200.132])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-cbed8bdaeb5sm1461553a12.11.2026.08.11.14.22.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Aug 2026 14:22:53 -0700 (PDT)
Date: Tue, 11 Aug 2026 21:22:50 +0000
From: David Matlack <dmatlack@google.com>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: Alex Williamson <alex@shazbot.org>,
	Justin Stitt <justinstitt@google.com>, kvm@vger.kernel.org,
	Leon Romanovsky <leon@kernel.org>, linux-kselftest@vger.kernel.org,
	linux-rdma@vger.kernel.org, llvm@lists.linux.dev,
	Mark Bloch <mbloch@nvidia.com>, Bill Wendling <morbo@google.com>,
	Nathan Chancellor <nathan@kernel.org>,
	Nick Desaulniers <ndesaulniers@google.com>, netdev@vger.kernel.org,
	Saeed Mahameed <saeedm@nvidia.com>, Shuah Khan <shuah@kernel.org>,
	Tariq Toukan <tariqt@nvidia.com>, patches@lists.linux.dev
Subject: Re: [PATCH v3 11/11] vfio: selftests: mlx5 driver - add send_msi
 support
Message-ID: <anuSqnU7WPy-9enn@google.com>
References: <0-v3-76f117ad04f1+28a90-mlx5st_jgg@nvidia.com>
 <11-v3-76f117ad04f1+28a90-mlx5st_jgg@nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <11-v3-76f117ad04f1+28a90-mlx5st_jgg@nvidia.com>

On 2026-07-16 02:03 PM, Jason Gunthorpe wrote:
> Wire an MSI-X vector to a dedicated EQ so the mlx5 driver supports
> send_msi().
> 
> Each EQ can be linked to an MSI-X vector, and the CQ can be set up
> to deliver an event to the EQ. Thus, when everything is armed, an
> RDMA WRITE posted to the QP generates a CQE, which generates an
> EQE, which generates an MSI-X.
> 
> To keep things simple this just re-uses all the existing QPs and
> CQs, so they generate single MSIs during memcpy.
> 
> send_msi() drains any accumulated MSI EQ events from prior memcpy
> completions, posts a small signaled RDMA Write, then polls the CQ to
> consume the resulting CQE (avoiding stale completions on subsequent
> test cycles).
> 
> Assisted-by: Claude:claude-opus-4.6
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>

Acked-by: David Matlack <dmatlack@google.com>

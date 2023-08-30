Received: from mail-pf1-f173.google.com (mail-pf1-f173.google.com [209.85.210.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 022817482
	for <patches@lists.linux.dev>; Wed, 30 Aug 2023 19:35:17 +0000 (UTC)
Received: by mail-pf1-f173.google.com with SMTP id d2e1a72fcca58-68a1af910e0so18656b3a.2
        for <patches@lists.linux.dev>; Wed, 30 Aug 2023 12:35:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693424117; x=1694028917;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=FRIggP1YvWWV3rj+5WU1Cj2nMoZrQOSbDSPE/2jMC40=;
        b=lMczMjns2HPU7uRzEfRwx1ybsvx/KVoZwLEymtMW+B7fuCgEol6kE53HeNpg//JT7f
         h0urG8b3ZcEi/4gbGyxl4fzTo2ZzkKANyEmXKy348kISeku3GXWHI5jdfViHTK53yttP
         WOVIxEXeqViaEU6dcrmAI5mofDA6z1BVptBnGOq7DX9Npa3mwFgNRT7q0d1L78xyPMnk
         q4eAxMEkuZYk9XThTnkrOUjZ2qCC/j8veTNjzgsXH2lEcgwiCLdpcqKvcXUhsRY3UkzP
         yemxczlgHSVxoUnYcM7YEDUut8QCQwtdlPrgKg80uVa2lQUBB+mUhmvwPMueR+ADmdNS
         nl6w==
X-Gm-Message-State: AOJu0YyuffaQj2ArbvVSvMtFMExWcgkOjyKmlSuIG4ywvQHCUb8ZigvK
	Dn3yRl0AO8Y2eBBM4K+G9dg=
X-Google-Smtp-Source: AGHT+IFQrRHqdxwX8FGNjPvqUjKyXjSnMn0Trjge4hVFu0U8vQRp3+U0I7ZSwpaRY7c/EBJygs2cDQ==
X-Received: by 2002:a17:90b:150:b0:26b:5205:525e with SMTP id em16-20020a17090b015000b0026b5205525emr2799578pjb.42.1693424117089;
        Wed, 30 Aug 2023 12:35:17 -0700 (PDT)
Received: from [172.20.4.71] ([208.98.210.70])
        by smtp.gmail.com with ESMTPSA id l5-20020a17090aec0500b00256799877ffsm1568485pjy.47.2023.08.30.12.35.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 30 Aug 2023 12:35:16 -0700 (PDT)
Message-ID: <a07bbc1b-0afb-4fc3-9da7-2dc1f6a4010f@acm.org>
Date: Wed, 30 Aug 2023 12:35:15 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] scsi: qla2xxx: Fix unused variable warning in
 qla2xxx_process_purls_pkt()
Content-Language: en-US
To: Nathan Chancellor <nathan@kernel.org>, njavali@marvell.com,
 GR-QLogic-Storage-Upstream@marvell.com, martin.petersen@oracle.com
Cc: jejb@linux.ibm.com, linux-scsi@vger.kernel.org, patches@lists.linux.dev,
 Stephen Rothwell <sfr@canb.auug.org.au>, kernel test robot <lkp@intel.com>
References: <20230829-qla_nvme-fix-unused-fcport-v1-1-51c7560ecaee@kernel.org>
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20230829-qla_nvme-fix-unused-fcport-v1-1-51c7560ecaee@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Reviewed-by: Bart Van Assche <bvanassche@acm.org>

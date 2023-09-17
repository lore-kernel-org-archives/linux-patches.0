Received: from mail-ed1-f43.google.com (mail-ed1-f43.google.com [209.85.208.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D52E76AAC
	for <patches@lists.linux.dev>; Sun, 17 Sep 2023 20:21:37 +0000 (UTC)
Received: by mail-ed1-f43.google.com with SMTP id 4fb4d7f45d1cf-5310a63cf7bso506267a12.1
        for <patches@lists.linux.dev>; Sun, 17 Sep 2023 13:21:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1694982096; x=1695586896; darn=lists.linux.dev;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=MT2s77/+t/5Zt0AJKF5jpT5srXOu3+XziZDQE7OQs9Y=;
        b=FvFSYv3lzcPxblmqSKAOJ1vGcF+UZEppmgegOM7fMEkHdOno9qmAE7wp5psTCN0yZn
         eF68x+lb6oSG6ylwjSnSMa4P4hCFk4gwEDzP9/tqBVs9Fm+w6hivRHNofGVkQ8nZAO1R
         SiMQVTYlcPy5ANox3GBXqMy+ElARM74bxSoKHMJfytNiLpLTAFU8YUjNLCSq3B3mnUm1
         eVAdbcawe7GjFpOPiAL2GFOa7jY6T+DkAeYpSK1AFresfLn09vMAvmsW8DXgA4ERarJ/
         UdapVt9OaduE3gVUb4BnG9nTPvJQDFQRknCBYuSepps1uOmte80GPyDzr3ChEf9ezOWs
         ph2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694982096; x=1695586896;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=MT2s77/+t/5Zt0AJKF5jpT5srXOu3+XziZDQE7OQs9Y=;
        b=vdKXBjjwEhwZF1JDi2lm7ZqbAebchQ7X4Llgs2ZflvDSdEHlt/nbvhQ49qpRNBEYit
         JI/iS0HZVUnUHAyBiowg1JuL3N/sqwdBB+C5L33g+q/zgDN9CyTx5bj3Krj7jHb6Y56u
         K2uAOQHBR30YYBXKWnirY7bgdbjnDF6sPbGf0U4FnU5X6mzEglrDTSnsS5FXB70ZlMH2
         be/phdA2PDcuNaL1v4h1JAsJxa7HZu+Q++01eVstMtjGBgLfVI4LPqw7WI5aJ/8kwu9J
         cDp1PpOfy9bnLeN5qgX/0JIW4ST8qQ3fvVy0JtFN9IQDsGRc0eTuWdcAjoBQ0ukxH4k6
         5vIA==
X-Gm-Message-State: AOJu0YwBgDbZN4ZaMcYSLaUUQRHLUXuvMjVeUT/bQDLZsP5zEDOmfpNr
	XZuq+b7i/5qCs/9qdcTU3mE=
X-Google-Smtp-Source: AGHT+IH2uDCu+lNmhA38xKp7G6491vz5k/A6md5hgEgEU/DemD64vORYrlIUG6193N3V/g0mKOVxtA==
X-Received: by 2002:a05:6402:1a57:b0:52c:b469:bafd with SMTP id bf23-20020a0564021a5700b0052cb469bafdmr5574517edb.41.1694982095809;
        Sun, 17 Sep 2023 13:21:35 -0700 (PDT)
Received: from [192.168.1.95] (host-176-36-0-241.b024.la.net.ua. [176.36.0.241])
        by smtp.gmail.com with ESMTPSA id x26-20020aa7dada000000b005224f840130sm5041888eds.60.2023.09.17.13.21.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 17 Sep 2023 13:21:35 -0700 (PDT)
Message-ID: <276965bc5bb339bc02bbd653072ceb50a7103400.camel@gmail.com>
Subject: Re: [PATCH 5.10 294/406] bpf: Fix issue in verifying allow_ptr_leaks
From: Eduard Zingerman <eddyz87@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, Yonghong Song <yonghong.song@linux.dev>, Alexei
 Starovoitov <alexei.starovoitov@gmail.com>, Yafang Shao
 <laoar.shao@gmail.com>, Alexei Starovoitov <ast@kernel.org>,
 gerhorst@amazon.de
Date: Sun, 17 Sep 2023 23:21:34 +0300
In-Reply-To: <20230917191109.075455780@linuxfoundation.org>
References: <20230917191101.035638219@linuxfoundation.org>
	 <20230917191109.075455780@linuxfoundation.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.4-0ubuntu2 
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0

On Sun, 2023-09-17 at 21:12 +0200, Greg Kroah-Hartman wrote:
> 5.10-stable review patch.  If anyone has any objections, please let me kn=
ow.

I believe=C2=A0Luis Gerhorst posted an objection to this patch for 6.1 in [=
1],
for reasons described in [2]. The objection is relevant for 5.10 as well
(does not depend on kernel version, actually).

[1]=C2=A0https://lore.kernel.org/all/2023091653-peso-sprint-889d@gregkh/
[2]=C2=A0https://lore.kernel.org/bpf/20230913122827.91591-1-gerhorst@amazon=
.de/=20

>=20
> ------------------
>=20
> From: Yafang Shao <laoar.shao@gmail.com>
>=20
> commit d75e30dddf73449bc2d10bb8e2f1a2c446bc67a2 upstream.
>=20
> After we converted the capabilities of our networking-bpf program from
> cap_sys_admin to cap_net_admin+cap_bpf, our networking-bpf program
> failed to start. Because it failed the bpf verifier, and the error log
> is "R3 pointer comparison prohibited".
>=20
> A simple reproducer as follows,
>=20
> SEC("cls-ingress")
> int ingress(struct __sk_buff *skb)
> {
> 	struct iphdr *iph =3D (void *)(long)skb->data + sizeof(struct ethhdr);
>=20
> 	if ((long)(iph + 1) > (long)skb->data_end)
> 		return TC_ACT_STOLEN;
> 	return TC_ACT_OK;
> }
>=20
> Per discussion with Yonghong and Alexei [1], comparison of two packet
> pointers is not a pointer leak. This patch fixes it.
>=20
> Our local kernel is 6.1.y and we expect this fix to be backported to
> 6.1.y, so stable is CCed.
>=20
> [1]. https://lore.kernel.org/bpf/CAADnVQ+Nmspr7Si+pxWn8zkE7hX-7s93ugwC+94=
aXSy4uQ9vBg@mail.gmail.com/
>=20
> Suggested-by: Yonghong Song <yonghong.song@linux.dev>
> Suggested-by: Alexei Starovoitov <alexei.starovoitov@gmail.com>
> Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
> Acked-by: Eduard Zingerman <eddyz87@gmail.com>
> Cc: stable@vger.kernel.org
> Link: https://lore.kernel.org/r/20230823020703.3790-2-laoar.shao@gmail.co=
m
> Signed-off-by: Alexei Starovoitov <ast@kernel.org>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> ---
>  kernel/bpf/verifier.c |   17 +++++++++--------
>  1 file changed, 9 insertions(+), 8 deletions(-)
>=20
> --- a/kernel/bpf/verifier.c
> +++ b/kernel/bpf/verifier.c
> @@ -8178,6 +8178,12 @@ static int check_cond_jmp_op(struct bpf_
>  		return -EINVAL;
>  	}
> =20
> +	/* check src2 operand */
> +	err =3D check_reg_arg(env, insn->dst_reg, SRC_OP);
> +	if (err)
> +		return err;
> +
> +	dst_reg =3D &regs[insn->dst_reg];
>  	if (BPF_SRC(insn->code) =3D=3D BPF_X) {
>  		if (insn->imm !=3D 0) {
>  			verbose(env, "BPF_JMP/JMP32 uses reserved fields\n");
> @@ -8189,12 +8195,13 @@ static int check_cond_jmp_op(struct bpf_
>  		if (err)
>  			return err;
> =20
> -		if (is_pointer_value(env, insn->src_reg)) {
> +		src_reg =3D &regs[insn->src_reg];
> +		if (!(reg_is_pkt_pointer_any(dst_reg) && reg_is_pkt_pointer_any(src_re=
g)) &&
> +		    is_pointer_value(env, insn->src_reg)) {
>  			verbose(env, "R%d pointer comparison prohibited\n",
>  				insn->src_reg);
>  			return -EACCES;
>  		}
> -		src_reg =3D &regs[insn->src_reg];
>  	} else {
>  		if (insn->src_reg !=3D BPF_REG_0) {
>  			verbose(env, "BPF_JMP/JMP32 uses reserved fields\n");
> @@ -8202,12 +8209,6 @@ static int check_cond_jmp_op(struct bpf_
>  		}
>  	}
> =20
> -	/* check src2 operand */
> -	err =3D check_reg_arg(env, insn->dst_reg, SRC_OP);
> -	if (err)
> -		return err;
> -
> -	dst_reg =3D &regs[insn->dst_reg];
>  	is_jmp32 =3D BPF_CLASS(insn->code) =3D=3D BPF_JMP32;
> =20
>  	if (BPF_SRC(insn->code) =3D=3D BPF_K) {
>=20
>=20


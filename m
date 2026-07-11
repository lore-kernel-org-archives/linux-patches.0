Received: from mail-qt1-f179.google.com (mail-qt1-f179.google.com [209.85.160.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E986175A98
	for <patches@lists.linux.dev>; Sat, 11 Jul 2026 17:38:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.179
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783791510; cv=pass; b=aMB3KbPPshjlkiibVFXa8BEgMG/Z3N2E2xcIU/9fvxFRwWGVNNX96yCjIgCKDBbxpY531gBGgxdN/9jKcuIDDwRqCfwFJumI8xTtzAjXqtHpiz4JTK4IzOawjwyMQliMfH5KcwA2O1LC+Qy+jGsdgPf0eSmbGttuH50AtsWvJI0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783791510; c=relaxed/simple;
	bh=2V2KLSDgcSUiK4L4iVVgXmIB4UUi2eZBF2ABdPzmDAE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=IuF57zcN9eXrwc78dVzIZ4//kVpUW1KzgJV7SDM12+Fzi7kyvYNPsgT9NR7LjvUkABHmLR8mMk+TltbU9VwHsXW+LvTDx9bnvcVnbT12oWbIKk/MGV/kuggGav6f0sZ4k7Oh52h1tmGJyI/nguKYaKEl7nPoPT2o91tpRtLljQc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=V3W+v+Lj; arc=pass smtp.client-ip=209.85.160.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="V3W+v+Lj"
Received: by mail-qt1-f179.google.com with SMTP id d75a77b69052e-51c15a5b265so166951cf.0
        for <patches@lists.linux.dev>; Sat, 11 Jul 2026 10:38:29 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1783791508; cv=none;
        d=google.com; s=arc-20260327;
        b=Pz33B048w0QLaOODm/ytczakEntcsVVrapAogGxeMcFegXEpEru3l5OtG5K/jPqIQk
         qadqfaV3nzPfpNGnpln42OBuPAOLxOZ+OZIDkld5SSBBiphHb5S/mfZZQmtK/m/q1o3t
         sELNDZZrFAg0y1/nNx5C8+azCjSVzPC6kSouc9XqFf/KjjYQW0H6ivxmzUraVhOd892/
         +9Wji7fzHdrh0k5xtGybNHl3aFH4qdPLdofcatmX2CCfQ0J5OiMWaS7ToNXeNRVyEr+a
         8qL6ttA0iMm+1/EmZb1DNgKbCnhDMa/NDDDaTNajsUwr3WaBD9/qoggmfKXiEJStqKzH
         q/lQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=2V2KLSDgcSUiK4L4iVVgXmIB4UUi2eZBF2ABdPzmDAE=;
        fh=SVsTzzK1knPTs8kX1aFNhM0U6pPtGLPM83lcu6lCDDA=;
        b=fb+JAj5miRp9jo76Qn0XFWgc69VY3vAbTmzxZbcbwITB8KSmXFahS52ZnnOoCHRqOA
         wqbfSSg6sc1LHZAacgJMHUsPFh90+VTUfy5pKmFdLKeDAif3rXipe4ThKOtHhdyMtirK
         bsAGB/DcQTJwAIsKAaNy5A1WI+wB+tAxUjpA5PElaCp/fcs/33mYq9RF5D/5CE72fLyL
         VZsy7ZJewSZGDSHkKHwPJWv5TbVwdx4ugej31xrcT4NFWjvglWcRi1XX0nJ6Mwu/+Hvg
         PGsxesJ30PuCdUbM8AheBJTpAqIwDKwIWoShIZ2rZwjyuFhUpoDL5+aXgyNL2KC/hbyg
         g4yA==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1783791508; x=1784396308; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=2V2KLSDgcSUiK4L4iVVgXmIB4UUi2eZBF2ABdPzmDAE=;
        b=V3W+v+LjM6d6kOWJTiistIhG7Xmzyg74DfoeBFtdt+OPGPTTSzVQWTyz+7acJeuUn1
         mVyev560+SJigWlbCWtZBK74OBHb0D/wwraOAF0Xi1ev/hA03/UvmLvbKiFpj0emCEql
         anEYayoWTkefLZWVodYxO6H9QrYkH7sjRNppUIljudVdBm20ADvDtgikUi4ifYjKEpuH
         xym+7DpxIAGplvk2DFdYX/m64lpteFpCjT4gcET1xAAsV4n0VzeoYZ4qjzZgLDtggENf
         m/rZ3+V9HN9G+9ZGd6Xgbv77y2K4svRO/lmFFbTNZH3acL9CLm6ydI7BP+Q875xv1ZXV
         Qg5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783791508; x=1784396308;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=2V2KLSDgcSUiK4L4iVVgXmIB4UUi2eZBF2ABdPzmDAE=;
        b=cpgLKYNhhADFmX+KSeoZ4G318s2ILUjdvlu5Ff2Nfu9uLC64eUfTArHpYnqRKfRFrX
         J+5tvkCBJrqPbn1nRs2eZwWDrYEuKpbfWgVCtyvfbuWJTRV2gTkNx5hKSYln5lruHKoJ
         uyb5TqZMf1530AgcL8Z93GAEQJyrCOJrHeF+/WqESOS6s7eV0jItm/cQKpoxA5b2djah
         N/aMDqpvkN3XtkRlekwdH8Ab0H/ovcqIKh7mBrcAA1x1DwQVU79wKexlpPzExUak/rcN
         Vxg99DnEaiggsjjeGQnNV1RBcaZyLMxmBB0tVgaAE6K/XwVBmHa5pxvk5cWd7cZdJFqd
         EJEA==
X-Forwarded-Encrypted: i=1; AHgh+RoQK3b7o2Dyy+kFJII6YgzjvlHyJUytmJvtclvLTIUliNDnh8F+RIZWi5CPuu4y8yjnv4ZqH4L3@lists.linux.dev
X-Gm-Message-State: AOJu0YwSA6cJYpIgZCziU/+79QWlOWzeW/h+nVRMz/1Pesy6oCfH+xZV
	zi4Oi8Ob3TKCvjPR8pX81vN/u3IYayKnbrk86rXsPKmEcWkdA+/WvkTnvLZy/y+6RcwZVNSEF30
	U2KLWyXCux8ZyxHiV+xOD57LAFEScmZ1ThIeOM/J0
X-Gm-Gg: AfdE7cmonXkH2LQgz+wcXSa35YBWAN/+t7TRFJ88ENSQ8VGpX1+AlTPCGt9cYRT2Ocd
	uh1c5NpQxKXy3N91a3GNj3xNMSaJd+srOQOXHNR+UEQ2nE/g545oqtxq13lsfyEymBq8pt6abgP
	t129hGA/8kkCXjSpnaheWbLwbRGcTbilJYKr075h7T9c2/ONsMUhHWkzV56sOecwEPE0yLcbtJT
	34YTqS3YUfnbxOXA4QzaqrJIRb5M1lHWLGvQnDVza+41xhsrVHCFghsZuMKzZsODH1R+Q==
X-Received: by 2002:a05:622a:4d95:b0:50e:5eba:cadd with SMTP id
 d75a77b69052e-51cbe261e39mr7732501cf.2.1783791507671; Sat, 11 Jul 2026
 10:38:27 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <0-v2-43074a57a53a+fb95-smmu_tlbi_jgg@nvidia.com>
 <2-v2-43074a57a53a+fb95-smmu_tlbi_jgg@nvidia.com> <akzh9qFEfi2umwDW@google.com>
 <20260707180811.GB226829@nvidia.com>
In-Reply-To: <20260707180811.GB226829@nvidia.com>
From: Daniel Mentz <danielmentz@google.com>
Date: Sat, 11 Jul 2026 10:38:15 -0700
X-Gm-Features: AVVi8CddI1hmY54sulNqNSmEvvFCdyTS1hLAJol6XLoIv6n6A3IeHHUQP2j41GM
Message-ID: <CAE2F3rDoBK8MeGJb=ZDRyjSYdjZac7R8-KiZf5WJnvUPfxbgbQ@mail.gmail.com>
Subject: Re: [PATCH v2 2/8] iommu/arm-smmu-v3: Move pgsize out of arm_smmu_inv
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: Mostafa Saleh <smostafa@google.com>, iommu@lists.linux.dev, 
	"Joerg Roedel (AMD)" <joro@8bytes.org>, Jean-Philippe Brucker <jpb@kernel.org>, linux-arm-kernel@lists.infradead.org, 
	Robin Murphy <robin.murphy@arm.com>, Will Deacon <will@kernel.org>, 
	David Matlack <dmatlack@google.com>, Pasha Tatashin <pasha.tatashin@soleen.com>, patches@lists.linux.dev, 
	Pranjal Shrivastava <praan@google.com>, Samiullah Khawaja <skhawaja@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Jul 7, 2026 at 11:08=E2=80=AFAM Jason Gunthorpe <jgg@nvidia.com> wr=
ote:
>
> On Tue, Jul 07, 2026 at 11:24:38AM +0000, Mostafa Saleh wrote:
>
> > The smmu_domain is only used for the tgsz_lg2, can=E2=80=99t we add tha=
t
> > directly instead? Decoupling the invalidation form the domain would
> > make it easier for KVM to re-use the code.
>
> Sure, done

I downloaded a newer version from your jgunthorpe repository, and
found that arm_smmu_tlbi and arm_smmu_domain are using the data types
unsigned int and u8 for tgsz_lg2, respectively. Can we align on a
single data type?

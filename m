Received: from mail-yw1-f181.google.com (mail-yw1-f181.google.com [209.85.128.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E1CF481C4
	for <patches@lists.linux.dev>; Sat, 26 Oct 2024 16:27:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729960028; cv=none; b=gcgDX/9sniVmK2CV4ZM+AqGypsMTc0cTfNGtZi7+CoRbImkFhgW0g12IB0n3iS12gUz2cB4ajDVkino1qjpPosY0CibLtZYcRr9Tdec3Ab7LjdSRTeWELhPVhhkAsHdBwjncThUSu///zUjiUc5mm2QqOMYQTyT8yXLTZvMD15A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729960028; c=relaxed/simple;
	bh=A2d4RnFX3pil5tSgYj3ITKZrgzZRv1eCgaJoYuXQWxA=;
	h=Mime-Version:Content-Type:Date:Message-Id:From:Cc:Subject:To:
	 In-Reply-To; b=p6lh1GsPJZSk6bMTC6XXWA/ZeyIC1EMcIOf6wTXJ7KQW9Y/sgHF+wnYIdPdAiGBfccytcuKJeGU0YClUZRM8CFqvvOaX9k/pFAVY8nyD/ca+iIdU7CVEx3Fqiwcf3Oc7oc7J1g4u6fScq+BCuobiS5XPqOYWNquV0R5yGIVp+cY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=JnT8BzVB; arc=none smtp.client-ip=209.85.128.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="JnT8BzVB"
Received: by mail-yw1-f181.google.com with SMTP id 00721157ae682-6e5cec98cceso26194727b3.2
        for <patches@lists.linux.dev>; Sat, 26 Oct 2024 09:27:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1729960025; x=1730564825; darn=lists.linux.dev;
        h=in-reply-to:to:subject:cc:from:message-id:date
         :content-transfer-encoding:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=uTtKtWKs11bD7iRvVxgQuCeRIcQVhURI1g77rkuqqLQ=;
        b=JnT8BzVB0pcH6zUWGv1JJ+NLzc6U2atC6QRKwMow//Q7t/8kj42rv5ChFVUdoZRF+i
         MwUQpwVXXfW5D2QdQdzY0jGZV7nL5ksmHCh5h9iRWNMcw1XFCQq98gmGHZMBsbri0Fmy
         z1hEcpcu/XMyqn98u0ptKnP58Pmv+y2+5wtKsPHgfnhH+2NiTm3WRAGzfs3e4OPAKRAs
         InToBGW9Ly3gwXVWIOHYjmCfUsrhtjJCRL7dPPEsd7cYJ1IqlYXbLKYOfmyH49Z+b7Nm
         be7K5EEfaMqypqMrrzdOaPORrTHrGZaffcsXY28aAVOwVpQyNl8GDd0bgPFvXSEYKfy+
         dyag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729960025; x=1730564825;
        h=in-reply-to:to:subject:cc:from:message-id:date
         :content-transfer-encoding:mime-version:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=uTtKtWKs11bD7iRvVxgQuCeRIcQVhURI1g77rkuqqLQ=;
        b=pSno4nLXcQqnTCKSuwj/0Cjd7QLitNySIuYtoWl5dssO+ZqNe5tKlDhBmPLu2A4dDZ
         X/L72KDPjxy4wGLdzrth1lyEGfrhDaEsk5tPd7CwkazpEEjVMysAuog8yNInes2kbvT9
         dj/v1ntXrEiwHxr/XKiYTA1gUiphub22pO2PBVZLg0PYkHzx2/ffpokpqtzz3BoOBijK
         ePLmC/3WeZXUHaamwCzBUewAQVm5KJgoeJD/ZItAQbgio1nfWVNHN/ZDSmzmUcE3ASd1
         yWMSYU4WJcZup4CT1RzdqRIWCQRFtRiU3Fi4wMos4gDbTq38axkhOF0i1FNOWeQF0ab4
         pieA==
X-Forwarded-Encrypted: i=1; AJvYcCUoo45FttC0eceIHLJtApiOvqF0m5amwE7iJE9exiOGcB5cH16wR2vzgyd2ivtLC8L9zZMq+2JF@lists.linux.dev
X-Gm-Message-State: AOJu0YznF6YdyMtNDxoxdDDf6RB7r2PlSYXCilCzSfYLoV1HRjseEhzW
	zGzBPuaEfgt/+h5941aQcAitwRLz5NIc0EoVICXwqCJmhvfoXlTa
X-Google-Smtp-Source: AGHT+IE0YLoWHP2mh/IBpJGKorWV3NwLz/xAUhPhboCkZTbimCpM5+rlYVLpVXcObR5/104mAOOHUw==
X-Received: by 2002:a05:690c:6f8b:b0:6e0:447:f257 with SMTP id 00721157ae682-6e9d89b85f5mr33296407b3.22.1729960025509;
        Sat, 26 Oct 2024 09:27:05 -0700 (PDT)
Received: from localhost ([174.128.181.101])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-6e9c6c96991sm7082527b3.123.2024.10.26.09.27.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 26 Oct 2024 09:27:05 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Sat, 26 Oct 2024 19:27:02 +0300
Message-Id: <D55VNB4366Q6.16EY7DUK2891U@gmail.com>
From: "John Mcenroy" <johnmcenroystudios@gmail.com>
Cc: <geert@linux-m68k.org>, <gregkh@linuxfoundation.org>,
 <linux-kernel@vger.kernel.org>, <patches@lists.linux.dev>
Subject: Re: [PATCH] MAINTAINERS: Remove some entries due to various
 compliance requirements.
To: <james.bottomley@hansenpartnership.com>
X-Mailer: aerc 0.18.2.r87.gd0484b15
In-Reply-To: <7ee74c1b5b589619a13c6318c9fbd0d6ac7c334a.camel@HansenPartnership.com>

Hello Linux Community


Alfred Tennyson
Freedom

Of old sat Freedom on the heights,
    The thunders breaking at her feet;
Above her shook the starry lights;
    She heard the torrent meet.

There in her place she did rejoice,
    Self-gather=E2=80=99d in her prophet-mind,
But fragments of her mighty voice
    Came rolling on the wind.

Then stepped she down thro=E2=80=99 town and field
    To mingle with the human race,
And part by part to men reveal=E2=80=99d
    The fullness of her face =E2=80=93

Grave mother of majestic works,
    From her isle-altar gazing down,
Who, Godlike, grasps the triple forks,
    And, king-like, wears the crown,

Her open eyes desire the truth.
    The wisdom of a thousand years
Is in them. May perpetual youth
    Keep dry their light from tears;

That her fair form may stand and shine,
    Make bright our days and light our dreams,
Turning to scorn with lips divine
    To falsehood of extremes.


=D0=90=D0=BB=D1=8C=D1=84=D1=80=D0=B5=D0=B4 =D0=A2=D0=B5=D0=BD=D0=BD=D0=B8=
=D1=81=D0=BE=D0=BD
=D0=A1=D0=B2=D0=BE=D0=B1=D0=BE=D0=B4=D0=B0

=D0=A1=D0=B2=D0=BE=D0=B1=D0=BE=D0=B4=D0=B0 =D0=B4=D1=80=D0=B5=D0=B2=D0=BB=
=D0=B5 =D0=BE=D0=B1=D0=B8=D1=82=D0=B0=D0=BB=D0=B0
=D0=9D=D0=B0 =D0=B2=D1=8B=D1=81=D1=8F=D1=85 =D0=B3=D0=BE=D1=80; =D0=B2 =D1=
=81=D0=B8=D1=8F=D0=BD=D1=8C=D0=B8 =D0=B7=D0=B2=D0=B5=D0=B7=D0=B4
=D0=9D=D0=B0=D0=B4 =D0=BD=D0=B5=D1=8E =D0=BD=D0=B5=D0=B1=D0=BE =D1=82=D1=80=
=D0=B5=D0=BF=D0=B5=D1=82=D0=B0=D0=BB=D0=BE,
=D0=9F=D0=BE=D0=B4 =D0=BD=D0=B5=D0=B9 =D0=B4=D1=80=D0=BE=D0=B1=D0=B8=D0=BB=
=D1=81=D1=8F =D0=B3=D1=80=D0=BE=D0=BC =D0=BE=D0=BA=D1=80=D0=B5=D1=81=D1=82.

=D0=9E=D0=B3=D0=BD=D0=B5=D0=BC =D0=BF=D1=80=D0=BE=D1=80=D0=BE=D1=87=D0=B5=
=D1=81=D0=BA=D0=BE=D0=B3=D0=BE =D0=B4=D1=83=D1=85=D0=B0
=D0=A2=D0=B0=D0=BC =D0=B4=D0=B8=D0=B2=D0=BD=D1=8B=D0=B9 =D0=BB=D0=B8=D0=BA =
=D0=B5=D1=91 =D0=B1=D0=BB=D0=B8=D1=81=D1=82=D0=B0=D0=BB;
=D0=9D=D0=BE =D0=BC=D0=BE=D1=89=D0=BD=D1=8B=D0=B9 =D0=B3=D0=BB=D0=B0=D1=81 =
=D0=B5=D1=91 =D0=B4=D0=BE =D1=81=D0=BB=D1=83=D1=85=D0=B0
=D0=9F=D0=BE=D1=80=D0=BE=D1=8E =D0=BA =D0=BB=D1=8E=D0=B4=D1=8F=D0=BC =D0=B4=
=D0=BE=D0=BB=D0=B5=D1=82=D0=B0=D0=BB.

=D0=97=D0=B0=D1=82=D0=B5=D0=BC =D0=BD=D0=B8=D0=B7=D1=88=D0=B5=D0=B4 =D0=BA =
=D0=BF=D0=BE=D0=BB=D1=8F=D0=BC =D0=B8 =D0=B3=D1=80=D0=B0=D0=B4=D0=B0=D0=BC,
=D0=A1=D0=BC=D0=B5=D1=88=D0=B0=D0=BB=D0=B0=D1=81=D1=8C =D1=81 =D1=81=D0=BC=
=D0=B5=D1=80=D1=82=D0=BD=D0=BE=D1=8E =D1=82=D0=BE=D0=BB=D0=BF=D0=BE=D0=B9
=D0=98 =D0=BF=D0=BE=D0=BD=D0=B5=D0=BC=D0=BD=D0=BE=D0=B3=D1=83 =D0=BD=D0=B0=
=D1=88=D0=B8=D0=BC =D0=B2=D0=B7=D0=B3=D0=BB=D1=8F=D0=B4=D0=B0=D0=BC
=D0=A0=D0=B0=D0=B7=D0=BE=D0=B1=D0=BB=D0=B0=D1=87=D0=B8=D0=BB=D0=B0 =D0=BE=
=D0=B1=D1=80=D0=B0=D0=B7 =D1=81=D0=B2=D0=BE=D0=B9.

=D0=A2=D0=B0=D0=BA, =D0=B2 =D0=BC=D0=B8=D1=80 =D1=8F=D0=B2=D0=B8=D0=B2=D1=
=88=D0=B8=D1=81=D1=8C =D0=BC=D0=B8=D1=80=D0=BE=D0=BB=D1=8E=D0=B1=D1=86=D0=
=B5=D0=BC,
=D0=9C=D0=B5=D0=B6 =D0=BD=D0=B0=D1=81 =D0=B2=D0=BE=D0=B7=D0=B4=D0=B2=D0=B8=
=D0=B3=D0=BB=D0=B0 =D1=81=D0=B2=D0=BE=D0=B9 =D0=B0=D0=BB=D1=82=D0=B0=D1=80=
=D1=8C,
=D0=92=D0=BE=D0=BE=D1=80=D1=83=D0=B6=D0=B0=D1=81=D1=8C, =D0=BA=D0=B0=D0=BA =
=D0=B1=D0=BE=D0=B3 =D1=82=D1=80=D0=B5=D0=B7=D1=83=D0=B1=D1=86=D0=B5=D0=BC,
=D0=91=D0=BB=D0=B5=D1=81=D1=82=D1=8F =D0=BA=D0=BE=D1=80=D0=BE=D0=BD=D0=BE=
=D1=8E, =D0=BA=D0=B0=D0=BA =D1=86=D0=B0=D1=80=D1=8C.

=D0=95=D1=91 =D0=BE=D1=82=D0=B2=D0=B5=D1=80=D0=B7=D1=82=D1=8B=D0=B9 =D0=B2=
=D0=B7=D0=BE=D1=80 =D1=81=D1=82=D1=80=D0=B5=D0=BC=D0=B8=D1=82=D1=81=D1=8F
=D0=9B=D0=B8=D1=88=D1=8C =D0=BA =D0=BF=D1=80=D0=B0=D0=B2=D0=B4=D0=B5, =D0=
=BA =D0=BC=D1=83=D0=B4=D1=80=D0=BE=D1=81=D1=82=D0=B8 =D0=BE=D1=82=D1=86=D0=
=BE=D0=B2.
=D0=9E, =D0=BF=D1=83=D1=81=D1=82=D1=8C =D0=B6=D0=B5 =D0=B2=D0=B5=D1=87=D0=
=BD=D0=BE =D0=BE=D0=BD =D0=BD=D0=B5 =D1=82=D0=BC=D0=B8=D1=82=D1=81=D1=8F
=D0=A1=D0=BB=D0=B5=D0=B7=D0=BE=D0=B9 =D0=BD=D0=B0=D0=B4 =D1=82=D1=83=D0=BF=
=D0=BE=D1=81=D1=82=D1=8C=D1=8E =D1=81=D0=BB=D0=B5=D0=BF=D1=86=D0=BE=D0=B2!

=D0=9E, =D0=BF=D1=83=D1=81=D1=82=D1=8C, =D0=B2=D0=BE=D1=81=D1=81=D0=B5=D0=
=B2 =D0=BD=D0=B0 =D1=82=D1=80=D0=BE=D0=BD =D0=BD=D0=B5 =D0=B7=D1=8B=D0=B1=
=D0=BA=D0=B8=D0=B9,
=D0=9D=D0=B0=D0=BC =D1=81=D0=B2=D0=B5=D1=82=D0=B8=D1=82 =D0=BF=D1=80=D0=B0=
=D0=B2=D0=B4=D0=BE=D0=B9 =D1=81=D0=BA=D0=B2=D0=BE=D0=B7=D1=8C =D1=82=D1=83=
=D0=BC=D0=B0=D0=BD
=D0=98 =D1=83=D1=81=D1=82 =D0=B1=D0=BE=D0=B6=D0=B5=D1=81=D1=82=D0=B2=D0=B5=
=D0=BD=D0=BD=D0=BE=D0=B9 =D1=83=D0=BB=D1=8B=D0=B1=D0=BA=D0=BE=D0=B9
=D0=A0=D0=B0=D1=81=D1=81=D0=B5=D0=B5=D1=82 =D0=BA=D1=80=D0=B0=D0=B9=D0=BD=
=D0=BE=D1=81=D1=82=D0=B5=D0=B9 =D0=BE=D0=B1=D0=BC=D0=B0=D0=BD!


Linux user
John Mcenroy
---
johnmcenroystudios@gmail.com






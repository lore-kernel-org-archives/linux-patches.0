Received: from out2.migadu.com (out2.migadu.com [188.165.223.204])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0B87601C
	for <patches@lists.linux.dev>; Tue, 26 Jul 2022 19:51:06 +0000 (UTC)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1658865059;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=j8K8kOujBoOdDO63jTo+/K5jiQuWFJ6DLw2RVxibl2s=;
	b=QR4npbiYMXGwcGsev/c88JVikRBUzwBy6XBV39YA6XFqOPswyefCZtP6map+KDt59WHZo8
	HngY6xo3XvhnlbMp3YqgmIyidXIV2VUWvSHmRrucQG/hSgSQAkJ/uLk8j3WMXOLqAuGogt
	4lnGNoejxd2Z9ozOCYtaE8LizyzeQm4=
Date: Tue, 26 Jul 2022 19:50:58 +0000
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: konstantin.ryabitsev@linux.dev
Message-ID: <a4b48e5acbb09f14fe5073b5380c39d8@linux.dev>
Subject: Re: [PATCH v1 1/3] Rename into Pumpkix
To: "Konstantin Ryabitsev" <konstantin@linuxfoundation.org>, "Linux
 Patches" <patches@lists.linux.dev>
In-Reply-To: <20220726-claim-for-great-pumpkin-v1-1-cba88581a0b0@linuxfoundation.org>
References: <20220726-claim-for-great-pumpkin-v1-1-cba88581a0b0@linuxfoundation.org>
 <20220726-claim-for-great-pumpkin-v1-0-cba88581a0b0@linuxfoundation.org>
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: linux.dev

July 26, 2022 3:46 PM, "Konstantin Ryabitsev" <konstantin@linuxfoundation=
.org> wrote:=0A=0A> Because why not.=0A> =0A> Signed-off-by: Konstantin R=
yabitsev <konstantin@linuxfoundation.org>=0A> =0A> diff --git a/README b/=
README=0A> index 669ac7c32292..4e9414583df9 100644=0A> --- a/README=0A> +=
++ b/README=0A> @@ -1,5 +1,5 @@=0A> -Linux kernel=0A> -=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=0A> +Pumpkix kernel=0A> +=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=0A=0AReviewed-by: Sockpuppet Squirrel <konstantin.ryabits=
ev@linux.dev>

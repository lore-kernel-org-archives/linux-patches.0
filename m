Received: from out2.migadu.com (out2.migadu.com [188.165.223.204])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9327033FF
	for <patches@lists.linux.dev>; Fri, 15 Jul 2022 15:47:48 +0000 (UTC)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1657899569;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=jMcvAyrDM5H5pWubQPPxFUe4jRWypbZv1LAYX1ZLfE4=;
	b=TZyP+Q+dTnV7QNrc+1S/zv3hOkpi9ZJaBptj7iLrBa0o3B7khyPoBnqVhsYDn6sTHI6C/k
	k40RfifYxdhM4ygeepEDrA9yRDBtkKwNNsKQKXNXLyanDkwshRof6VY3GxGrh1505fKNvq
	coEfgHBfLT0lj7Dg6oA/ToB0Egwm0xQ=
Date: Fri, 15 Jul 2022 15:39:25 +0000
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: konstantin.ryabitsev@linux.dev
Message-ID: <54c0f98fb45e28e865055e766c3245ab@linux.dev>
Subject: Re: [PATCH WIP v1 0/3] Fake series to test out b4 submit
To: "Konstantin Ryabitsev" <konstantin@linuxfoundation.org>,
 patches@lists.linux.dev
In-Reply-To: <20220707-my-new-branch-v1-0-8d355bae1bb5@linuxfoundation.org>
References: <20220707-my-new-branch-v1-0-8d355bae1bb5@linuxfoundation.org>
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: linux.dev

July 14, 2022 3:52 PM, "Konstantin Ryabitsev" <konstantin@linuxfoundation=
.org> wrote:=0A> This is a fake series that I created to test b4 submit. =
It will be sent=0A> to the patches list, but it's not a real set of patch=
es. You can ignore=0A> everything about it.=0A> =0A> Signed-off-by: Konst=
antin Ryabitsev <konstantin@linuxfoundation.org>=0A> Suggested-by: Sockpu=
ppet Squirrel <mricon@gmail.com>=0A=0AThis is a cover letter trailer with=
 a mismatched From.=0A=0ATested-by: Mister Mismatchy <mricon@kernel.org>=
=0A=0A-K

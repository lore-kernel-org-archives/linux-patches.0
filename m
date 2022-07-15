Received: from out1.migadu.com (out1.migadu.com [91.121.223.63])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FD9F33F0
	for <patches@lists.linux.dev>; Fri, 15 Jul 2022 15:47:48 +0000 (UTC)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1657899639;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=2MiO4HrKp/8a8cTiMXyx7G0aeCnq7wi2e+zvgijcaDQ=;
	b=AVN2erBuwDPWhoWosZSfQpP/uhgVswYXvpsmGDOIS+XYvUYycsb3iD6q1sCab08Di2HwYj
	n9205UuqRPiG2YsiBztb/rF9kB98AAOlgFimqyn1+qdvbSuIHraWxRF3yfFFiCdbU/7vMf
	hO/KPRFb0NsFtoFT/vbiv+k764nxGog=
Date: Fri, 15 Jul 2022 15:40:33 +0000
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: konstantin.ryabitsev@linux.dev
Message-ID: <1a538ccd35b99ed3bd1b12649a03cbcf@linux.dev>
Subject: Re: [PATCH WIP v1 1/3] Rename Linux into Konix
To: "Konstantin Ryabitsev" <konstantin@linuxfoundation.org>,
 patches@lists.linux.dev
In-Reply-To: <20220707-my-new-branch-v1-1-8d355bae1bb5@linuxfoundation.org>
References: <20220707-my-new-branch-v1-1-8d355bae1bb5@linuxfoundation.org>
 <20220707-my-new-branch-v1-0-8d355bae1bb5@linuxfoundation.org>
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: linux.dev

July 14, 2022 3:52 PM, "Konstantin Ryabitsev" <konstantin@linuxfoundation=
.org> wrote:=0A> This is not a real commit. I am using this series to tes=
t b4-submit=0A> functionality.=0A> =0A> Signed-off-by: Konstantin Ryabits=
ev <konstantin@linuxfoundation.org>=0A> Suggested-by: Rando Stranger <ico=
n@mricon.com>=0A=0AThis is a mismatched trailer.=0A=0AReviewed-by: Single=
patch Mismatchy <konstantin@linuxfoundation.org>=0A=0A-K

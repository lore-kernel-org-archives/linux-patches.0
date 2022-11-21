Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0443FA4F;
	Mon, 21 Nov 2022 10:04:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:Content-Transfer-Encoding:Content-Type
	:In-Reply-To:From:References:Cc:To:Subject:MIME-Version:Date:Message-ID:
	Reply-To:Content-ID:Content-Description;
	bh=OhAv9HhT3JCF0LrLmmieia1a9etGEyC8D5lE+WIuK/8=; b=Gxfx+IGJ86koKmJjUqNLrpPpQ7
	oEqsTcXwXMhKcJ+sG4XC1fHMYL3t1Oai4reOUsMgaq92VsqtL/SbJVXrhPVjQugCmhB7o82+RyDQT
	FAJ+w6z1U6Mb49Z+Qo3DutSBqOe7Zf3IoPxSK9rgz61abnMY4N3+Hipa3pp6QFi4un3JHQqPGVSt5
	2LgN3eJL5XW7/1rdoi74w1IY6aWZhreYX3pqq5M5z/yx6Sm2DWtPebsf/W8gnunLovf4yQCugKnw3
	mgKEs8+dsvsHW0iuxJv2Y1bKBSoLIj5p4P+vz2+0VEsykpbCUqtHBfkYrFjsA7TDKU0XBJHID5DBu
	DzFtOB8g==;
Received: from authenticated user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_128_GCM:128)
	(Exim 4.94.2)
	(envelope-from <sylvestre@debian.org>)
	id 1ox3WM-000822-TN; Mon, 21 Nov 2022 09:55:23 +0000
Message-ID: <8aa23f88-2986-b90b-0fbe-c2c15251cbe2@debian.org>
Date: Mon, 21 Nov 2022 10:55:22 +0100
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:108.0) Gecko/20100101
 Thunderbird/108.0
Subject: Re: [PATCH] ARM: Drop '-mthumb' from AFLAGS_ISA
Content-Language: fr
To: Nick Desaulniers <ndesaulniers@google.com>,
 Nathan Chancellor <nathan@kernel.org>
Cc: Serge Guelton <sguelton@mozilla.com>, Russell King
 <linux@armlinux.org.uk>, Arnd Bergmann <arnd@arndb.de>,
 Ard Biesheuvel <ardb@kernel.org>, linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org, llvm@lists.linux.dev, patches@lists.linux.dev,
 "kernelci.org bot" <bot@kernelci.org>,
 Sylvestre Ledru <sylvestre@mozilla.com>
References: <20221114225719.1657174-1-nathan@kernel.org>
 <CAKwvOdn67r3ZYb5XZkae3i5797GGV3=8=nLC7kT2d4On3OEm5A@mail.gmail.com>
 <Y3aMxfhBw9YsWiKr@dev-arch.thelio-3990X>
 <CAKwvOdmYO0_m3+uWHe_C=7y1zgePQzc27Kd6Pep7Ja_pgbNPZw@mail.gmail.com>
From: Sylvestre Ledru <sylvestre@debian.org>
In-Reply-To: <CAKwvOdmYO0_m3+uWHe_C=7y1zgePQzc27Kd6Pep7Ja_pgbNPZw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Debian-User: sylvestre

Le 17/11/2022 à 23:51, Nick Desaulniers a écrit :
> On Thu, Nov 17, 2022 at 11:34 AM Nathan Chancellor <nathan@kernel.org> wrote:
>>
>> On Thu, Nov 17, 2022 at 11:15:09AM -0800, Nick Desaulniers wrote:
>>> On Mon, Nov 14, 2022 at 2:58 PM Nathan Chancellor <nathan@kernel.org> wrote:
>>>>
>>>> Fixes: 1d2e9b67b001 ("ARM: 9265/1: pass -march= only to compiler")
>>>> Link: htps://salsa.debian.org/pkg-llvm-team/llvm-toolchain/-/blob/17354b030ac4252ff6c5e9d01f4eba28bd406b2d/debian/patches/930008-arm.diff
>>>
>>> Would you mind using
>>> https://salsa.debian.org/pkg-llvm-team/llvm-toolchain/-/blob/snapshot/debian/patches/930008-arm.diff
>>> as the link instead? The link on this commit message is a diff against
>>> llvm-14, not ToT which is currently llvm-16; the context is quite
>>> different as the logic moved source files completely.  Though it does
>>> look like Sylvestre has not yet cut a 16 branch for debian's patches.
>>
>> I would rather use an actual hash to reduce the risk of the link going
>> stale from either a branch rename or file rename/removal. I can use a
>> hash from the snapshot branch instead, if that would work for you?
> 
> It doesn't matter much to me; I trust your judgement; you pick.
> Perhaps that depends if the snapshot branch has stable SHAs or whether
> they change over time? Maybe Sylvestre can comment on that.
Yeah, it can change overtime. I have to rebase them from time to time.

Cheers,
Sylvestre



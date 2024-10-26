Received: from sonic309-51.consmr.mail.ir2.yahoo.com (sonic309-51.consmr.mail.ir2.yahoo.com [77.238.179.109])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1FA31D517C
	for <patches@lists.linux.dev>; Sat, 26 Oct 2024 12:22:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=77.238.179.109
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729945358; cv=none; b=jnYjSApZ+HIGtjeFTo66Zf8+LIsM+N2/y/m3Z8DmPv7xLFzyEbsa/sQLM986W054ZErJtPGiR4v8Dgmol+wMck/DM9JJqLPX5k/g0WEGlvSRT0wkq85orUwW3TdDhELHNeoQtbczPHUl0HIovydcwGUiv1dPepdp0uHz4uBC8RM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729945358; c=relaxed/simple;
	bh=go3b8+bhsET8YZzj8ujOrrkgLL6pVga5CXyuOsvlnMA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=O4aiLaSMm5VCajw5rPMV9SLKA5XfAVB3/R4TZWvBt6vb6DljafaZDNpLDZcEm8xrvagZh9ZsaEg4cU61TLQ1jQ0s5DtLChKY/uWgv+/zelYzcD1GUBxJ9QrnpaNujStZjUh5944SYqhqSKRo1neYxv4z2R5VvY4jdCPRjsTih8Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=yahoo.com; spf=pass smtp.mailfrom=yahoo.com; dkim=pass (2048-bit key) header.d=yahoo.com header.i=@yahoo.com header.b=aClFSzE2; arc=none smtp.client-ip=77.238.179.109
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=yahoo.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=yahoo.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=yahoo.com header.i=@yahoo.com header.b="aClFSzE2"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1729945354; bh=P51wJr7duKSOzJP+RLnRLsN7BWwnapD2FQB2vht4gk8=; h=Date:Subject:To:Cc:References:From:In-Reply-To:From:Subject:Reply-To; b=aClFSzE2EO6MI7AfRheXLhW9GuxWqshkTUHa8i9gWTNKuVKdw/75q+bNzNeugqDjTZGFOkqi8Wg518a1KOWhWmGj/xOZg0VT4bdiTGL+qbb/ymp9SjYqFCkISNziVHV03M74O/rmMOji9OSfrc9LN8a/xWH9g+0WEGAftb+egA2dWtxDdrEOyM8Touo3KCqDPm+QfD+zY7e5UkWy6yx2Ulevy3ls+8d6UxeWmJXDyM8vzONRSKZVqPJ1AHBw0qzXO1dfoqyRiD5zYmjoMpj9cY8C8zzTgXQwvjopP/RXHb7z1PeHDfpoUeRKhbmTm07vcWNs8iMXSSz8xlJsJZF93g==
X-SONIC-DKIM-SIGN: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1729945354; bh=CVQ/DIOn90OHKxSFEEU/BJ/HVKuAL9Rkzhh8XTcI08q=; h=X-Sonic-MF:Date:Subject:To:From:From:Subject; b=jgI7T0Eqio+ezAqlhEKHz7l5Ug0PkmJbOndbHD25mJdk+mhVA8RZ1YrYMdg/d+Dd9vZSnYRemo555Bns6jB4cAqf+hNwHg/GpCyhl2Vm0m5BTTB0thlNpn2QrGpa5t9+cgnn+EHYoD7Q7eLQ45ULm6W9C8NBIDj3nleSZu9FbtHT3h4DpfDyMa57KMozBirPh8MuBefrClXErKacb+Me6Wr7FSN5cUYV3bOGrntSkwfhZesLUz1IupAc13KPlCJCDB5tGVCzq3C8S16D3tHdjRAx3sVsfIdtd2WBsmOKb7HV10hmBGqSO0+RfbnAwY3/z1OsmAugqcnjD7zPm444Iw==
X-YMail-OSG: CCpbcnsVM1lY4qV.UCriipJrxLJr7TJpxxL8ZoaW1jk2idDRTVj6tfDewSu8ksX
 knSNyTnoj7n.PnVihEw3gHUGJq93jsChUEgpS0ay.zOPgJcdVCoy_TU_Xjkh0cxdldOG_icjHt8h
 5ZyVjN5979CGhecfgwfSbY2ujY1jZN6huoiFN0QGfhNQ0IIqg9lK8R5WAFYs49hqGyfT0mgIbKo_
 dZDw7cjIGDGyyk5nBjOKn5h2PqOF1K4yCyYYi0GU.Pgte0kqYMBrEXnJX7ikQAhK6CKyto7.VuMj
 Rii.hm_6dkFbdRL5RxHf19zB648MN1Bb91dVMd_gLXYdFZo5cnGo1Lz3loOVHBgQjXaEgTdxjgnN
 8d.f6Ni2lIKLF9qIZNGjTs5JXxzJo6hSuTlyWIgBpNZRAkPD_zwgJea55qaLV21wQvTR.3EismFr
 zwIe9KR9lMn7lP2piUWGrvQCj6DRorrUDZ7iw2OBYXhJWIXOQjCBGqOWIZHzopBH86iSsQ5mvopg
 daGcqYrrUv3a0y9L4bnODrIShG6EhPUF61BAj1_0U7thlpmqMf5_odSQWduoxrHAZQojbBPAPUsM
 v_9ssm5sB8RV224ZjLlaXOESXL6mMx9hY0MUv6yYwZe.pdcK9qzPl7oMeKVM3BzVmXhRwglsaIpZ
 nx5nzZX.VWKobwV0dbdfdWF8iApce1GcTJGNYybOdZB911MQOaqepUMnWRG8L1BsWRGHkGBRwBkm
 qbBcyE_Jy70JxelSsaFB9p0.HkRQ6.LzlllwJWuzVdxEMOOPcbctP6ks0zrippAmlJ11b5fpp905
 fbWjIxIGcC1aq.h6v8oHkt6_rY_A49ZDa8NRFOujj5go.v_YP8jl5Kh8Lpg_HKl6Z7wmpQM9cVP6
 rpfHCZgM4Sj4anKPZXINtxL5qaLajCFiLICkmJyE.aYYIw74aZZ.I66wMaFetPcWvasGh8GOmJ6j
 AFwNkYX0KnfMZOervIU3ntU.5toH2F978Np2iifa9ZwxJ87Rpf7Wg5lR74QvK3LyQKfPWAnogASp
 Cs8yi8tPSpkI5cEQiScuX_5iA9E220TL_3OKVRTHcC9YOI2hPNLhEL7FqKIDDINSN2lIK6ULPKiT
 Y98KLOYcTz5xjl_cwnkGiWcbyDIsAXPSPBPjUlsPtCv7dm9nr0apw8BtdX0wGCk8d2pJ45IyVMCf
 BGFGs8kRsP0yTog_rg0yGC.3rRU18iGm2262atjsi4.zKeOW5zgj458ix2nMoK4mD9P1mp4BhxP6
 61P0sJyXuxPVnpg66EoSiAsoOkVoKX5EdWCNpmoSRlCZtsDWBpfFYhyz5WfCZ4e.WhpV2.PPROmz
 OyqheVhxuYz_QGqEtqZQEkoOmPh5P1lAg5vo9NRp2hCR4sVvX9eYA891tdAOqSjyoVVO7H9HWHrd
 rISCmaQdGBCMJcHSu7p0LyNeigHgSwnZkP2LvWncPJzkLcpO.yYGiPOQObdp4SmqFWukl5HBKY0Y
 X_sepbOql1VvipXEKBTb9vS7RMcnStR_mMjPXS5eJNlxlnNvsDSv9YoOri57Fw4E55bnSnVJjGAp
 ayuZjydD5VuHJsQ58u17MMDRF8vEycPoadO4oFEfqak3q48M6_O9YD4Y75roX1DQLnIWTAgV2WPy
 LztVVy0NfGkCk9RH73k3X9vEOYpCkGNJyQod9apP7nBy3FWonxlLGWWtjmSQnirt1GTHh1U8wDP4
 ZPRKWMlZpdy_Ru98wDiheo_d5T6Wehq5SztGX_vaPhG_vywMREm6vYZPoXaqcY3SQg4cfPPdgmN.
 x5VCZVYZGrqqmWNlhzThpeehY0IJPa1wOJEZ8nhO6JW9h3sH5hUbfSmst9yNjPZmLy7jHkKDTznI
 FofCpe7CYIk5WJz0MX0XpS5ogcSp2dOqz8qfAaaVo4PbxQv_u0oS3KjeomejC4NgaxzAx_h0BXA5
 qsIMywirep0ZadSJ9JoErTHwE379hkwyICbUqtl3LcvQJjmOvaJ8IaQiB7VB5fGky7HVc5dWO.t3
 zqnu5R3qJrH47p2CLKGifjxRU7lRUXDnq1neZ4swxCOdkKyD7RmMpC6HfvSMPGCvQ6imGKuXFpHA
 OL9RHZ9DZBTpGy.EZktYZ28mg3xoyNJM279Xo4kXZQg1ZswoHDHZfVZ4.nrrn8fGZm78gcAh.7hn
 v6.de7nYvIJFiuYEl6qf9ovTr9EESqlXamA5Qs5x.WFd9lDWbxEbhgtdK.HH_7QlLZiPFGYzyHnV
 fNYSwPzUsRmSTvAvV_sM_G20UZLhmlzhEIeAaAf3qYCl.Q4jw5YxwkEIuPC1IB_zD8kEa0xwyjex
 l6X9fpe8zRg--
X-Sonic-MF: <angrydev@yahoo.com>
X-Sonic-ID: 8f07d0da-16c5-4b5d-bcb3-8b71328083c7
Received: from sonic.gate.mail.ne1.yahoo.com by sonic309.consmr.mail.ir2.yahoo.com with HTTP; Sat, 26 Oct 2024 12:22:34 +0000
Received: by hermes--production-ir2-c694d79d9-sckcc (Yahoo Inc. Hermes SMTP Server) with ESMTPA ID 2829b462a676ec037ae6d22e9ca17f15;
          Sat, 26 Oct 2024 12:00:17 +0000 (UTC)
Message-ID: <c82d67b1-571e-4b93-8def-b454839a22a3@yahoo.com>
Date: Sat, 26 Oct 2024 14:00:17 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] MAINTAINERS: Remove some entries due to various
 compliance requirements.
To: James Bottomley <James.Bottomley@HansenPartnership.com>,
 geert@linux-m68k.org
Cc: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
 patches@lists.linux.dev
References: <7ee74c1b5b589619a13c6318c9fbd0d6ac7c334a.camel@HansenPartnership.com>
Content-Language: en-US
From: Angry Dev <angrydev@yahoo.com>
In-Reply-To: <7ee74c1b5b589619a13c6318c9fbd0d6ac7c334a.camel@HansenPartnership.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Mailer: WebService/1.1.22806 mail.backend.jedi.jws.acl:role.jedi.acl.token.atz.jws.hermes.yahoo


>> On Fri, 18 Oct 2024, Greg Kroah-Hartman wrote:
>>> Remove some entries due to various compliance requirements. They
>>> can come back in the future if sufficient documentation is
>>> provided.
>> This is very vague...
> We finally got clearance to publish the actual advice:
>
>     If your company is on the U.S. OFAC SDN lists, subject to an OFAC
>     sanctions program, or owned/controlled by a company on the list, our
>     ability to collaborate with you will be subject to restrictions, and
>     you cannot be in the MAINTAINERS file.
>
>> What are "various compliance requirements"?
>> What does "sufficient documentation" mean?
> The documentation Greg is looking for (which a group of Lawyers at the
> LF will verify) is that someone in the removed list doesn't actually
> work for an OFAC SDN sanctioned entity.
I'm pretty sure those sanction lists existed before LF did this move and
they never played a role up until now. It's necessary, I guess, to remember
that those lists are made by political entities for political reasons. If
it would be all so very clear, I really wonder why it is still possible to
work together for Russians and people/companies from the US on the ISS. I
don't really know, but I strongly guess there are companies invoked which
also work for the military on both sides. As most of you know there are
general elections in the US in a couple of days and it's not completely
unlikely that a very erratic and fickle person will be the next president.
It's also not very unlikely in that case, that those sanction lists get
extended because of "I don't like them: Put Em on the list.". So you are
giving a part of your power to US politicians, something nobody who
submitted code to the linux kernel ever agreed to. You are changing the
rules as you go. It's also important to remember that the linux kernel is
not a (commercial) product of the linux foundation or owned by them. It is
(currently) maintained by people who work for the (US based) linux
foundation and it is actually a problem for/of them and it looks a lot like
they (ab)used their technical power to get rid of it. (which can be seen on
the way it was done - which disrespects all rules of submitting a patch).
And as the cherry on top, everybody who disagrees is called a "Russian
Troll" by the project leader. I'm not - believe it or not: idgas. You
really should check your tone, especially if you run out of arguments. Or
is it you just hiding behind lawyers and want to emphasize your political
stand? I would agree in this particular case but neither your nor my
political stand can speak for a global project like linux. In any case: I'm
done with this project and hope somebody in free country will fork.

>> I can guess, but I think it's better to spell out the rules, as Linux
>> kernel development is done "in the open". I am also afraid this is
>> opening the door for further (ab)use...
> I agree we should have been more transparent about this but I think it
> would be hard for someone other than Greg to get a Maintainer removed
> on the "compliance issue" grounds so it's probably not that open to
> abuse.
>
> Regards,
>
> James
>
>
>

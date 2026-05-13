Received: from mout.gmx.net (mout.gmx.net [212.227.15.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3768C4ADDBF
	for <patches@lists.linux.dev>; Wed, 13 May 2026 16:44:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.15.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778690673; cv=none; b=syhar7etR/T4fcU9ndEiJuNjnNNXLh2vAxBKElS6qrMXIZnaIKJGWXtuu41GL/ansmimhqxyaRbzfgFU+bbxuZoAGGe3Kt7IHVIhVUaFFfdY28gSE02ntAkczI1O69N8fCwblImumZes6rqBDjPe8CRaL5Db9YS98/Q1C/8vVEI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778690673; c=relaxed/simple;
	bh=1R+q0brxT5FCSRMOO/LqKS2K1GLvRDjYnI692aiflvw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=avQi0RVmb5GET3sCvruTRuST9jOINHqHyGCw2WyHBqXQWRlbz5XCMde35e0890SUmH8KlIs7TtqaTk3qJQlcvwXsf8A2DNBuvuguixB95rfcvK+3SG0Xl7Tbey4nIGc/VINRyn5vVSNVaVt9zpnbLr2fbU9hkxh9C3CH8fW2hLA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.de; spf=pass smtp.mailfrom=gmx.de; dkim=pass (2048-bit key) header.d=gmx.de header.i=rwarsow@gmx.de header.b=mCBSLcmk; arc=none smtp.client-ip=212.227.15.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmx.de header.i=rwarsow@gmx.de header.b="mCBSLcmk"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.de;
	s=s31663417; t=1778690669; x=1779295469; i=rwarsow@gmx.de;
	bh=1R+q0brxT5FCSRMOO/LqKS2K1GLvRDjYnI692aiflvw=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:Cc:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=mCBSLcmkYFsvYkz6Azbcki/XWZZ9CXuYbDaDGEtOgNcS34WAvkck384zBIWMjvdJ
	 sK/qjjFoEH7ap/4PY3Jbdiq+N7SEnQcKKqrs/G08UJdfU89fa1DHfodAERPDmQrqV
	 9N5Z1HVDMt8q4gq3gs8tI0wxZZHuNgLB6da//THlK7FfEieGYin90e+xcQQWq8XN1
	 WTgXje/DB9fdYqHb54VghYd9ja656VzNDMgBdk0JHlV4WJRWCBIaRAt6BRUTqIfdh
	 FukUsMerjhVU4ajFfEr7G2Bh+xRkAMNrMtBATlOc1pQjNd/PF6U321WZRQlIQIUdr
	 E2GgSHBvZWc/CAyx2Q==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from client.hidden.invalid by mail.gmx.net (mrgmx005
 [212.227.17.190]) with ESMTPSA (Nemesis) id 1Mxm3Q-1xJzaF1RIU-0177Hg; Wed, 13
 May 2026 18:44:29 +0200
Message-ID: <600196ef-5d69-4fdc-ab27-a37f1391ad97@gmx.de>
Date: Wed, 13 May 2026 18:44:27 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 7.0 000/305] 7.0.7-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, conor@kernel.org,
 hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
 sr@sladewatkins.com
References: <20260513153754.934923793@linuxfoundation.org>
From: Ronald Warsow <rwarsow@gmx.de>
Content-Language: de-DE, en-US
In-Reply-To: <20260513153754.934923793@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K1:eOwG/Ka96ee+f5LGzNrl3gcR8WxsVmDaCieVSUQI5Jp8cI4Up8T
 hXGwAX/fl3hskM1tyCTseIYdNEW/4/D+aR4bGPpKD3eQ4dLi2I2b+n7MJh/APUPGME+tWdM
 +o3J+++Sb8kL13MA8og3oTEKQnwiSPJmE39c2KS9Hpf1V+NNwitXYIhAJ4M+3ILX0968mXX
 Ffplj3QrMqYthd4VfARtQ==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:xEA+5PTMOao=;lgjRgxAQFWi6OBADkkl1M04lJt9
 /axKmp/9Jqh3UrjFrXCAETu+A3UEAPkY2NabRmmHYUolRdUd8K59lyzGSvAmCq9Aiyy421T4D
 sLP2c0SGjcrwlSSvRySEPlS+QzE9hoW5q2ktrz+FGZLn6def2d8d3M3qyu1eD+GyMfLUCzHJE
 p09UEKZjg0xrJcXCKZU1ouo3pwE82U11mYQRMplJQU5AMqXvNtT0OqCQlr5vBgB+oV+L0vDha
 GVoXjtZODKzAzmIaLb9vZvgsfL/VfRx/NkpcFp9U5OS/vC7t2ViuRvCIvh1622Ndqjg1CXZ1U
 bFZnNIcpUDuztSSaHrtahdEx5vWWXQS9vjaOFUj6bATaeTf0OGUnfXIwoOo1CYvbMNWaNi2pd
 BQKgkVpXHLEsJNbDvNiIHibePQNSXlW7S/yk1B7ktMZZ/JocY0+YtsBoJj7xfbQYUj/+SZyeq
 Czxdczu0SPdu8PsLFrAsaBlvbUBcyqwu7cneCV9kN0duJCS7lUI50/x/qgNHAY8ckhyTBm0Aq
 AW97tyeX3vtLhj+IL/prF9AyLK0vJi7aGBWGRNdTkjuolH8tf18iEinehAtmB1/MOpttkDOay
 0DLftDcsas6l6HclrEGjpG3wbnT7Z9Ipf8n+ogQArx+ejR/yDsRTVNMZj//z+MhbDw34Pu4Xa
 b52DrXJQHOiE7CC4SvKvDEx9b99YTOxcVgnbsPO61TchDILMTZF6jV8bFE3op+DS6m9fVjwRs
 +DhI7XAO0W7xXnEjYTdc98N+ljjWXiIPpx5Ztc6Li2lPp2dX/RQtCBb//xXqubDbgAWQomIPk
 WCGc/8Icr0aXRgukcydl6uvJjhVgJ6dy/qEELtoiqyaMU1g1YKusZ4+MrjPQ5/kpA3XC1CU49
 p5KOZXuFry47JT5NDqTyG58RdyzVds2dcCBUbt/cFU8MnHM97BstrUhvwxHfykON/ucWHAgrO
 gtJ9Fe7zxZPWDu5BY/7drXTrVOCdsCwFJARGbrFaueGV0cMLKMLZRkb18cvNtf8ZIyGBmOWEW
 /HssobRhH3DoKQlClGB6lrXsBWyGYpfSW6K4kZLpoL+Ddz1mdMF237OW6XaH5+oJFqTnd/I5u
 tts5mT2kOz+NyEJ5sfvxJ4Knh6vRMerqPtEIzNP+OXBUdoqm5MGeHGTbNpyA+c3Bm+njo6z+k
 nQlkCnKJtUql701TSzjt7Vtzw7q/k6UpA04tHVvKGBCoMU6r2fqvyrafaXxrKqAYA5p1I2In8
 LhC+Ewld6Ou9YHxN3NLayVU5oehRITxblM1KuCJYXVsTrH5fEf/4SWfmTSi425ENH/SzEn5V7
 oqq20/aeLRvAWCxTF8DBTVj/ataQlQHNZXpQ/Qk1WeR7n9IeCOHuajzvFU3LfMyoCLBAfpn9m
 Xl28f//+pXoPGrb2RXgdCPZLpd0olyBdudwAMMMubms+Rjj4PE1E6DDWWkhn0gsCDDONu41+O
 bgNMM7l07tjiAKayHMJhnXkzx9K1O5fUFWVLq6vt8YSX6Ye32fYfVw/5SEdYXmXRn0gWVVvEl
 hekuoJCqFNLCIyH2yf1MuhAGBcdU8pLL50LyvDpQI/1PhhjpzNuxXXpBxhB60yI52yrmt8xsI
 tks3bWQi07XqelYcr2VOF9Lba7+LufE8vAl7c4Q1t+NqDeD+z5OdSDVNoTUlddlxbSlOMMHak
 2Y7VKQ9nMRS9Skl2XsQ7BPWsjkbd248cTY9rt2/nb/R5wtDr/29Ie7M8ibcKrgoFh/VgnVgNL
 WNJMebpUsgLETl14PmPaoJXSHNsqPA4lfxjtoHP6LFIVKdM3tsUWUmdeq1wX4vOoSORiz4Ghl
 6TsuzYLBOiPVwsyIKvQBnURQ/V/CI5/jacWjf6CdXwNOJnXYDw8wR6oLsXfa5+T3gudZuD/9l
 aDdn9ilEvnDRH4JnBTLBVq1+1H4CR5PWmLHKsqQr1dTpjddl+S66c+7+AgG6MICjn/FmXuNOx
 3gqj+mkGPrL20ffyumG/e2O5ypDXUiL0+UwzhF25obfVZFXzTlztrA9LQY7ynXeTywTo0K4ml
 wol0wE/weHEtjqbw4S58uIbHtTKyfAj/Cy41rXFZB3JhUdeOmuK/XsZpCGWIhZ8FLx7sw/KHi
 RC3X0cDePOrqErxlHouQ76LTSsOuVAf5pVnuU5Jye9rhajSF7sCpuM3P7NyXev7RB7NnmHj8r
 cTU66e6g+AzN5twLeV4DX4RybtUzlcbdeEVkcyraPjjMo2EFFC3dvPxYnY25Uj8rASkp+u9J7
 wuweRtio5p+cBb8nu8hEp2+Vm3stX6C2rXPb8NJfe3LDqEJ/YbE2C3rYQo8pl5tXjepfj5lt7
 pACmRCbb+HTR1y4GmZXppuq5zZ2iuIcQxHta04asY8f+0P5Kl29QWiHpfQl+NDz57nPWXj+wn
 hIqCjw4yQXh3HJC61xfNlvM0q4T5J+I3YRJlyaFTSkkkpYPseCp9E4dka6ffGtF3h1B4HdMrW
 /Fr+/UZLDGLH+42nHCCKyrKkbNFrE1/u4+hmtnH01jVkIm7i/cAnUmQD9BRby1Bjp0CV5Yfzl
 oOwqBuHSpU57ZilxVZ5knL8ouygIdWK/knAiQOhZZpmn//b5v7baL620sk6BylloT2F8O8Bj3
 VLbQVaFTPBDJbJ9XoWd5183EUQCXto44As6/OZKHPdyOXmmcwmAH8+TBEAW92wkAzstthEEHx
 RTHt5bJlN3YF20BKxMXzBeSix6l56VnflQf8cPB6g2g2AjlqBHsDEfZChPc6uV+DN4VryfeYH
 l9ApNTKR7z7jHgRsk9zRijn0ZBF5k+hkbzN+CBvHV3LDFYmG/7bPoMIAzS+wvc9JFLXEhBmRD
 B+lbm08E2lwLvSyra1THBle/ajqBUVxz8borcyp3JjG5Px+luUY93xfPdIFOsyL91y/oQCilx
 UuMDsfWjsfCQP6jshaQcyIIzdQU1+gS3u2MMh89rSBjoMTE6msyMYq25Vzl5f36PkC1+km6tB
 pffWKtYTgpxFMaPwwyqeeB9BVvreIuW6YZDdwx0hgljia28CKQ45Mm0jv/ZAm93R0KEd0EBuE
 IGW7DRXrWxmXBH+vhtIq+iZppc6LeAYElhDiYdi6qqSqji6UT1WgHdqowh+LxEJshEvbv7J9q
 snFhNiVv191aXpFUqcT6kFd+b77ZxzeApr7sJohYWKTgTLxcBgLqDlw9G2th2KsnUwVnk26hj
 +F8qoYOQsX0xomm5oy1r7obLScJ5+62nbqAysDfPQ8S+gvwGCEPhKHZVGogAPWvhklEImA+O6
 3yD56zJfU2oc0FGFvURS443BaomTSs9sFEG5WFbNyU+6UjEaYmO4qiv0ZccQ7kVCS1dsW+ffa
 jZSDe3yupt21zPlkbWnNDvxWJkr1S13oKEZjx5AjuVR0euDz027p06XvY4VRhsPjWbP8fuovW
 uK0V+dJKVUZQ1dGwqr0t8D1ivqC9GtSZzwx0lnXY0xsfaxj/jHrnWdAWrJJeuuYE7r2KvC2M4
 xB1kj8cFq3mfNqcsFCHz19ejwx7klOnP9IUWhj1CL46RC9jsBCppF4dpjx/n1j6lY/slwxoHj
 1InU4fuERvzOHaprYeu50Llvct2i9UBjpsK+pdcMFBGSve7/kBmvHLKI8EtOvJZ1QdmQ5hh22
 P7HPAWHdarAeOi82h7AHUKhgJEwugYkAk2bG2hiZum7BgXRbxjKEnKP6xgLSgFaENoPo4X6L5
 NqPbNVhhtRfjmL1QBJVVy0wySgZqWMjPlwwGPJ7v7G2+z04QOPyRtDUO2dCLHy31X5pAc5TZe
 DOl6L1ydn0M9KI/1JaHTfG4psFKP6WQoVbo0C4PBBLR2cOWHxmBJIB4U1fwG2VD2zFaAVVpnB
 oJf9lqA72bjRYe+wQm30fWGUZ5C38oED4aMphegHIJj+FJW08yx+AFudvqkkOC+DtvEDmTDKy
 b2Z6wzW+yHYn2bHZ3HzCMwpNMo1Au2HcBp4/s35sqSAm/TphO+r6ndPWX/7pJjHCcwL6lY3Yp
 WWP3iQnaG8A9PiTHTjiHqQrCrpJ78kth0U5Ox7wnIWZxeQjXgEm9Xxybt+wxXwMDYdoFaUTuQ
 F7QyWJq3UYd+V1fxoalaC/ohLhV2l5qhj/QGbbo/RVG1fM3Dw8Wa+aPzhaTTeik818Z2tcF9Q
 bm/Mk6Z4j0FTULnMDquQmdpUMpytmM//Q8cWizxMveVOzyuf3aRiLxAGYvtWbTvt9CS1hSudv
 +oYFN3MPlQcHnc4vVY161iYvJ0yMmxEre+LAjieOScLheHzGXCVOgpErCL3jBZf8rJKFbZANN
 FWYg2foKqgWsuidigjZslR8FBuWG3IiIoXNot7f6JkoGqaTmSW5QMLQsFz9Z8BepnDPCe15wW
 CqBmEVLBfbsmI/DJsXDtFQbs7xKw6Y+GAr3kgA5AK4Vhpp4tPeWmnJfcNed+9Sl/w6EP6SBrF
 rlgt+nXSlQ9pv26G944F4DlOr7OAEYn8Hq3XbC7XnRbUk2TyL9/cHKVKWQG59Xfnulhui6JAK
 bObPsaz51p+agIO3OALO1shDWNAJ2N7uOY6FxHiJ9dBf3wXFw2+Hao/XkSexlWG+xBQe5On0M
 Q3wYKKLovW/KKkJ3reMIwphqUbLrIb94et6kwfW4qitNLhGUDd0sHiTwDOK8NEarqz84mQbvY
 ugNcORs4QQb7odxXdZYLuYm+oBlgZU7pIS42sDv+UL1IK89+sOpuWaoVMo7QQaE6iPJ9/2LM9
 lJtzjsbUZvoX+qxUeBkATUzA10w+sHckR5eXuhcA9+3lNL1FSu2t0PO9NJ0Hr8T15S2pXgZ9O
 W0mVkwt/mFoT/VmIfZl0XJvBcDOUgwJTlcEj0mXc4r8plSskP/6NPUE4MlZa6s1gQBTWDvPyl
 3Jp6uYhEhrFTNy4s2H79sC4hygIn2Rbw7246dtHy2B4ge5pFbwYEzEL6tDMrqZ3fnFzvLog+N
 vFXTUA2bMorVI33iAeU5hkq9MOjzL+7TVYI6gSdfD/fhrdIvKReRCNX1bo0IjdRn28N9MyESf
 taLYrTnFTBXFDDSH7oCvMy+frOJyfK3tn7bopuJaNe+4cIBl5trHPylTrqjvrX+8mF6IMo6rV
 b+r7o94N9XoWUP3lC0E2uyiXLd/8qT7tQpXwosaLqrCDoEoUjNBbKf44wV34mSg5ZBSVFbO+I
 6AD/fBibuAVLvzo9CcO31q8Gyd+1/QF+nbDMgifHV+WgZA5GAULu2fFJW1nhsw5pmIzAO+SXd
 ya8HEHYkLUniwkCiIlo3GADxbQwos8WhP9jjQsZzdJoWCAUxA3ePErLdfN74mJoKvtGxI0rGR
 n2Vhn06ZB/lZfnJ+c5dacHHKp8MIR+ZU39Crp2NVtxv9TyDXI8klveNe4pXzVBKCOTBbv0I2W
 n9YQ2FkTEuL

Hi

no regressions here on x86_64 (Intel 11th Gen. CPU)

Thanks

Tested-by: Ronald Warsow <rwarsow@gmx.de>

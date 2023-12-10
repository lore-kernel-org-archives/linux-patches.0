Received: from wp530.webpack.hosteurope.de (wp530.webpack.hosteurope.de [80.237.130.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5C577472
	for <patches@lists.linux.dev>; Sun, 10 Dec 2023 10:25:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=leemhuis.info
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=leemhuis.info
Received: from [2a02:8108:8980:2478:8cde:aa2c:f324:937e]; authenticated
	by wp530.webpack.hosteurope.de running ExIM with esmtpsa (TLS1.3:ECDHE_RSA_AES_128_GCM_SHA256:128)
	id 1rCH0D-00059W-C2; Sun, 10 Dec 2023 11:25:37 +0100
Message-ID: <baad16de-abb3-4f0f-a8b0-fcbc25d36423@leemhuis.info>
Date: Sun, 10 Dec 2023 11:25:36 +0100
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.6 074/134] wifi: cfg80211: fix CQM for non-range use
Content-Language: en-US, de-DE
To: Sven Joachim <svenjoac@gmx.de>, Jaron Kent-Dobias <jaron@kent-dobias.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
 patches@lists.linux.dev, Bagas Sanjaya <bagasdotme@gmail.com>,
 Johannes Berg <johannes.berg@intel.com>
References: <20231205031535.163661217@linuxfoundation.org>
 <20231205031540.189275884@linuxfoundation.org> <87sf4belmm.fsf@turtle.gmx.de>
 <ZXWFyGnQjSO5ZKwl@mail.kent-dobias.com>
From: "Linux regression tracking (Thorsten Leemhuis)"
 <regressions@leemhuis.info>
Reply-To: Linux regressions mailing list <regressions@lists.linux.dev>
In-Reply-To: <ZXWFyGnQjSO5ZKwl@mail.kent-dobias.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-bounce-key: webpack.hosteurope.de;regressions@leemhuis.info;1702203941;87a5a9bb;
X-HE-SMSGID: 1rCH0D-00059W-C2

On 10.12.23 10:32, Jaron Kent-Dobias wrote:
> On Saturday, 9 December 2023 at 11:05 (+0100), Sven Joachim wrote:
>> On 2023-12-05 12:15 +0900, Greg Kroah-Hartman wrote:
>
>>> 6.6-stable review patch.  If anyone has any objections, please let me
>>> know.
>>>
>>> From: Johannes Berg <johannes.berg@intel.com>
>>>
>>> commit 7e7efdda6adb385fbdfd6f819d76bc68c923c394 upstream.
>>>
>>> My prior race fix here broke CQM when ranges aren't used, as
>>> the reporting worker now requires the cqm_config to be set in
>>> the wdev, but isn't set when there's no range configured.> [...]
>> After upgrading to 6.6.5, I noticed that my laptop would hang on
>> shutdown and bisected that problem to this patch.  Reverting it makes
>> the problem go away.
>>
>> More specifically, NetworkManager and wpa_supplicant processes are hung.
>> This can also be triggered by "systemctl stop NetworkManager.service"
>> which does not complete and brings these two processes into a state of
>> uninterruptible sleep.
> 
> I have a similar problem that I also traced to this commit.
> [...]

TWIMC, there is another report about wifi problems bisected to above
commit here: https://bugzilla.kernel.org/show_bug.cgi?id=218247

Didn't CC the reporter here due to our bugzilla's privacy policy.

Ciao, Thorsten

P.S.: Thx for Bagas Sanjaya for bringing it to my attention, much
appreciated!

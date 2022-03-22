Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87EB16465
	for <patches@lists.linux.dev>; Tue, 22 Mar 2022 21:38:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42856C340EE;
	Tue, 22 Mar 2022 21:38:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1647985117;
	bh=mayOljjBZi5XbJ520N414EV0mK79u+hTckASm2U4Fk4=;
	h=Date:To:From:In-Reply-To:Subject:From;
	b=M1zxtOXDuAHXyFQNUchAF8EWgJ0PLP1xO2wFHpN/o7MYoj6j1S38zCRWjk6MIWdx+
	 gSadTGe1mzM8d7eeavJu0EJRBtyHafw9083pWoWrNF1eFkmWpXDsAN121A9/fw/2s4
	 fzrdrGFv3WfriurBKSszhdUQVh4tEWFmuNEsIZuo=
Date: Tue, 22 Mar 2022 14:38:36 -0700
To: joe@perches.com,colin.i.king@gmail.com,akpm@linux-foundation.org,patches@lists.linux.dev,linux-mm@kvack.org,mm-commits@vger.kernel.org,torvalds@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20220322143803.04a5e59a07e48284f196a2f9@linux-foundation.org>
Subject: [patch 002/227] scripts/spelling.txt: add more spellings to spelling.txt
Message-Id: <20220322213837.42856C340EE@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>

From: Colin Ian King <colin.i.king@gmail.com>
Subject: scripts/spelling.txt: add more spellings to spelling.txt

Some of the more common spelling mistakes and typos that I've found
while fixing up spelling mistakes in the kernel in the past four months.

Link: https://lkml.kernel.org/r/20220216152343.105546-1-colin.i.king@gmail.com
Signed-off-by: Colin Ian King <colin.i.king@gmail.com>
Cc: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/spelling.txt |   16 ++++++++++++++++
 1 file changed, 16 insertions(+)

--- a/scripts/spelling.txt~scripts-spellingtxt-add-more-spellings-to-spellingtxt
+++ a/scripts/spelling.txt
@@ -180,6 +180,7 @@ asuming||assuming
 asycronous||asynchronous
 asychronous||asynchronous
 asynchnous||asynchronous
+asynchronus||asynchronous
 asynchromous||asynchronous
 asymetric||asymmetric
 asymmeric||asymmetric
@@ -231,6 +232,7 @@ baloons||balloons
 bandwith||bandwidth
 banlance||balance
 batery||battery
+battey||battery
 beacuse||because
 becasue||because
 becomming||becoming
@@ -333,6 +335,7 @@ commoditiy||commodity
 comsume||consume
 comsumer||consumer
 comsuming||consuming
+comaptible||compatible
 compability||compatibility
 compaibility||compatibility
 comparsion||comparison
@@ -353,7 +356,9 @@ compoment||component
 comppatible||compatible
 compres||compress
 compresion||compression
+compresser||compressor
 comression||compression
+comsumed||consumed
 comunicate||communicate
 comunication||communication
 conbination||combination
@@ -530,6 +535,7 @@ dissconect||disconnect
 distiction||distinction
 divisable||divisible
 divsiors||divisors
+dsiabled||disabled
 docuentation||documentation
 documantation||documentation
 documentaion||documentation
@@ -677,6 +683,7 @@ frequence||frequency
 frequncy||frequency
 frequancy||frequency
 frome||from
+fronend||frontend
 fucntion||function
 fuction||function
 fuctions||functions
@@ -761,6 +768,7 @@ implmentation||implementation
 implmenting||implementing
 incative||inactive
 incomming||incoming
+incompaitiblity||incompatibility
 incompatabilities||incompatibilities
 incompatable||incompatible
 incompatble||incompatible
@@ -942,6 +950,7 @@ metdata||metadata
 micropone||microphone
 microprocesspr||microprocessor
 migrateable||migratable
+millenium||millennium
 milliseonds||milliseconds
 minium||minimum
 minimam||minimum
@@ -1007,6 +1016,7 @@ notity||notify
 nubmer||number
 numebr||number
 numner||number
+nunber||number
 obtaion||obtain
 obusing||abusing
 occassionally||occasionally
@@ -1136,6 +1146,7 @@ preprare||prepare
 pressre||pressure
 presuambly||presumably
 previosuly||previously
+previsously||previously
 primative||primitive
 princliple||principle
 priorty||priority
@@ -1297,6 +1308,7 @@ routins||routines
 rquest||request
 runing||running
 runned||ran
+runnnig||running
 runnning||running
 runtine||runtime
 sacrifying||sacrificing
@@ -1353,6 +1365,7 @@ similiar||similar
 simlar||similar
 simliar||similar
 simpified||simplified
+simultanous||simultaneous
 singaled||signaled
 singal||signal
 singed||signed
@@ -1461,6 +1474,7 @@ syste||system
 sytem||system
 sythesis||synthesis
 taht||that
+tained||tainted
 tansmit||transmit
 targetted||targeted
 targetting||targeting
@@ -1489,6 +1503,7 @@ timout||timeout
 tmis||this
 toogle||toggle
 torerable||tolerable
+torlence||tolerance
 traget||target
 traking||tracking
 tramsmitted||transmitted
@@ -1503,6 +1518,7 @@ transferd||transferred
 transfered||transferred
 transfering||transferring
 transision||transition
+transistioned||transitioned
 transmittd||transmitted
 transormed||transformed
 trasfer||transfer
_

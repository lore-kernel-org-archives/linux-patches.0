Received: from abi149hd126.arn1.oracleemaildelivery.com (abi149hd126.arn1.oracleemaildelivery.com [129.149.84.126])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BAF98F55
	for <patches@lists.linux.dev>; Sun, 16 Jul 2023 19:30:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oci-arn1-20220924;
 d=augustwikerfors.se;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=1X2J9Yn20F/BEmGq9y/x0FBrrb96P1AoI6JRoNuLx48=;
 b=hhYQHeWeU3tWLwkcoWUkS7C8RqLLTN6gdAl5d6RHOsD6mFDYNN8KTBTyAWR1eU5dwokmiavsFfW3
   vaVh+c1pvIKb0/s449uLlfHT75ASed294nTe6MVD72MtEHaIUizStnmLW2MMRLDGQaOOYbTZRfdx
   4TG6s9sGdM1hM7dXn/dvWh0YijIczoFWwn+0CR0uRS5EsoUOBGipTodMsYTCzc4OXH1UeQSSspC/
   gL57Z5mEtHYUIjERn1ZS7VYl6DQUgwMoM94eezODEqvOMNDYxRjbPt/BK+qPiZNXd2ZCL8D/MCJz
   tGab/fg6WDylUfGRsWgR1YD0Ns8z2bMUR9lz0w==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-arn-20211201;
 d=arn1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=1X2J9Yn20F/BEmGq9y/x0FBrrb96P1AoI6JRoNuLx48=;
 b=MTAHRUN67jyzpHcQ1EHcYebCrL+Zrea6rPHGTQrZrZydIfK3QTKJUkEdwF/jYpwcsSLEzv4ndYAy
   oNGWRfebaxV6iVN23mJ2mWABO6rDERU7zT81tw7cEHeVILT0oqndir+WvHhjf25x9rzdqd0FYMe0
   oR/PUQlQ7NRn6jcXvDR6MuPaC8PYjMHGsU79z+go/9wHjSqf0ku2vqKsDXTQXG9A8B45KrinkjVt
   aTmxrs0AnN21QifSEZfaH58rgBxE7PbDE6Ycp8ifPWiF5r7oCFuAliujU1ivrOT2xH8XWwV6CK9/
   BOCgtNbV7xdiyA/SnSWn6kQIB2wROYijXjCZLg==
Received: by omta-ad1-fd3-401-eu-stockholm-1.omtaad1.vcndparn.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20230629 64bit (built Jun 29
 2023))
 with ESMTPS id <0RXW0073ZM78V730@omta-ad1-fd3-401-eu-stockholm-1.omtaad1.vcndparn.oraclevcn.com>
 for patches@lists.linux.dev; Sun, 16 Jul 2023 19:30:44 +0000 (GMT)
Message-id: <0206e2ce-ff33-6017-15ab-cc89f1eb7485@augustwikerfors.se>
Date: Sun, 16 Jul 2023 21:30:41 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-version: 1.0
From: August Wikerfors <git@augustwikerfors.se>
Subject: Re: [PATCH] nvme-pci: Add quirk for Samsung PM9B1 256G and 512G SSD
To: Nils Kruse <nilskruse97@gmail.com>
Cc: stable@vger.kernel.org, Keith Busch <kbusch@kernel.org>,
 Jens Axboe <axboe@fb.com>, Christoph Hellwig <hch@lst.de>,
 Sagi Grimberg <sagi@grimberg.me>, linux-nvme@lists.infradead.org,
 linux-kernel@vger.kernel.org, patches@lists.linux.dev
References: <b99a5149-c3d6-2a9b-1298-576a1b4b22c1@gmail.com>
Content-language: en-US
In-reply-to: <b99a5149-c3d6-2a9b-1298-576a1b4b22c1@gmail.com>
Content-type: text/plain; charset=UTF-8; format=flowed
Content-transfer-encoding: 7bit
Reporting-Meta:
 AAEqHmCrKsOnH195OEdwrfg9FTxZzACbRkpk03nDz2o7ewDk7A9Vjq6UenQjGOdN
 kAaYT+day+D9LnofH23wmNDd3QZ5lX8jc6pjaI5su1zrpUl23gXFdchnRkybaBpm
 0onSwBtO7FP+fNKgMc9NfBUaXca4AEJ4WQtbMs5Qg0/CRSe9VXS+49p/O4u7OrNr
 EiH15TvMGY3a+UB8z89JqkEdoPxBBB7MndUO2K85v1o/3kGOnWnKfvXlSoWXs6lw
 nTZrRXhNwhbAWm52rUT/4wOixkLy9Y6XGMkOox7BjI6tCam3mL3hIPay1iVSH1db
 D0VvcTi1Pfx+JFX3bSufYTaFEY/TpgWa6iuKSSSyEix4+KypCDqkYGl7A7IUDqF9
 TQhwKHRRo057GucwkQv9R1Ae4gTIIJbzgB2zfJyaYZmtGPMWy39S6W6vk7YYjKkW NT4=

On 2023-06-11 13:41, Nils Kruse wrote:
> Add a quirk for Samsung PM9B1 256G and 512G that reports duplicate ids 
> for disk.

Is this the same issue with suspend as [1], [2] and [3] or is it a
different case?

[1] https://lore.kernel.org/all/20221116171727.4083-1-git@augustwikerfors.se/t/
[2] https://github.com/tomsom/yoga-linux/issues/9
[3] https://lore.kernel.org/all/d0ce0f3b-9407-9207-73a4-3536f0948653@augustwikerfors.se/

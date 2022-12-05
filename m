Received: from cmx-mtlrgo002.bell.net (mta-mtl-001.bell.net [209.71.208.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5C927C
	for <patches@lists.linux.dev>; Mon,  5 Dec 2022 20:56:31 +0000 (UTC)
X-RG-CM-BuS: 0
X-RG-CM-SC: 0
X-RG-CM: Clean
X-Originating-IP: [174.95.50.166]
X-RG-Env-Sender: dave.anglin@bell.net
X-RG-Rigid: 637E567F025B31A4
X-CM-Envelope: MS4xfHWLsyQnvV+6wW7Y13BGOKSxPgedrECV41AJlFvaH8ie8l9s3Mc0YfG+IQQUPiWP3+3tDh5hjUaFHmA6Ug+ATliWmb7hK6IJ4WpIkyY0or12KkGHOJB3
 pZ1idXT1LfGvYlTHm7ETCxx6+o5DeGHuWjMIxXCxsMZ36amqDM+qxZ/jEBje4IRk2wJ/OiEyr/1dFJer1amtGRUuhvQ6ri56n5Wdwy/omj/cBrmxMAM2XorF
 niVc2FoOaC/iYwazbWf1nWe2a4byfS0ARb+7t8IIcPRR6jeHwHfr5jNl36BL1TKiFU/JVAZ4/+7ulNuh/0cwk0rrUJhaComME1iH60Z6ZWASp/ocRnnZ0nQO
 XOrkK7YcPDZDBatE0Vwgqk0VbJBj29iCl0u2gymwntTY4Px+QIwbCc8wGvtYjTYMR5aWSG4CPZ3S903whWXpvDAL9+UtfoULeD8Eo+BB32YRDcZ2cJA=
X-CM-Analysis: v=2.4 cv=d6kzizvE c=1 sm=1 tr=0 ts=638e5a1e
 a=DujhYzqEYufUJi90e8Godg==:117 a=DujhYzqEYufUJi90e8Godg==:17
 a=IkcTkHD0fZMA:10 a=FBHGMhGWAAAA:8 a=cWDybZAjoRrfc75ItIkA:9 a=QEXdDO2ut3YA:10
 a=9gvnlMMaQFpL9xblJ6ne:22
Received: from [192.168.2.49] (174.95.50.166) by cmx-mtlrgo002.bell.net (5.8.807) (authenticated as dave.anglin@bell.net)
        id 637E567F025B31A4; Mon, 5 Dec 2022 15:52:46 -0500
Message-ID: <6d2d24fa-28ac-581c-1ea6-a16bbd37b916@bell.net>
Date: Mon, 5 Dec 2022 15:52:47 -0500
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.1
Subject: Re: [PATCH 4.19 094/105] parisc: Increase size of gcc stack frame
 check
Content-Language: en-US
To: Helge Deller <deller@gmx.de>, Arnd Bergmann <arnd@arndb.de>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, Abd-Alrhman Masalkhi <abd.masalkhi@gmail.com>,
 Christoph Hellwig <hch@infradead.org>, Sasha Levin <sashal@kernel.org>
References: <20221205190803.124472741@linuxfoundation.org>
 <20221205190806.296201818@linuxfoundation.org>
 <dfa8305f-f52f-4322-a22e-9a1e90fcfad4@app.fastmail.com>
 <4676311f-1c08-a611-a3be-48e841093e45@gmx.de>
From: John David Anglin <dave.anglin@bell.net>
In-Reply-To: <4676311f-1c08-a611-a3be-48e841093e45@gmx.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 2022-12-05 2:58 p.m., Helge Deller wrote:
>> My understanding of the parisc overhead was that this
>> was just based on a few bytes per function call,
>
> What exactly do you mean by a few bytes?
> On parisc the frame size is a multiple of 64-bytes (on 32-bit)
> and 128 bytes (on 64bit).
On 64bit, the frame size alignment is actually 16 bytes.  The minimum frame size is 80 bytes.
That's 16 bytes for the frame marker and 64 bytes for the register save area.

Dave

-- 
John David Anglin  dave.anglin@bell.net


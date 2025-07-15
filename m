Received: from mout.gmx.net (mout.gmx.net [212.227.15.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1D351922C0
	for <patches@lists.linux.dev>; Tue, 15 Jul 2025 14:53:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.15.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752591241; cv=none; b=WIwN0kfQ9EmXGQ/Z5zZpfCdKZOG5CODny7swFwKaNEqu1GeSh1/20/PhrVnjHqJszbvE9yawejQ7zC/bS7+R67rOdpfYaJhRhOS+a103fTBFkgxB7aVcEAiA31qajpQu/QLg2zhoE7B73vNLhnLwxlIeBXss647lZ4gaErpu1To=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752591241; c=relaxed/simple;
	bh=W5ID3OY7yfWGGgbtnZevjVWj3uINdDq2sxdewYF9kdo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ebTTPQ8SXgOl3zmlo9g5B401SpNC+newWxK7ELE25AR9hmJS9ulukzB7jUSLM7fdAAK1BF9rr1bHbzvfR/z7SGgpUpP3WG38yHjcjfUO9kxF2abNjga+z9S0LZfYRwaBs8iXVip4hYcaVzYJntlzK3frCSYiyHJxltmP+x5A6yg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.de; spf=pass smtp.mailfrom=gmx.de; dkim=pass (2048-bit key) header.d=gmx.de header.i=rwarsow@gmx.de header.b=qVmTgbDu; arc=none smtp.client-ip=212.227.15.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmx.de header.i=rwarsow@gmx.de header.b="qVmTgbDu"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.de;
	s=s31663417; t=1752591202; x=1753196002; i=rwarsow@gmx.de;
	bh=W5ID3OY7yfWGGgbtnZevjVWj3uINdDq2sxdewYF9kdo=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:Cc:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=qVmTgbDuDLfRGMXvO6kMV+4jLXvA28eQZNBmnLG+PjUozTVpPDB4v7Ctf/Jyz+30
	 rdkFsRW8huJXfkfBWAao4RhmcD9tlp0VijCXSaSh7vvgGGXKjW0Uh7tFmKYO2HAHC
	 SRIylFZfReNpIkt3e0V7Co0RcU5PuWE+eTe7C+NXuu+zYZXEwziGKW1qxzDIb2xOB
	 zdziDY10Cr4XPTie6+NcoDOYLGajZNI0O2nrmxd7Msj0hPsne/cz9WUKceusfgHTp
	 2piiooZiVnj3m5Kvkga/y4xVZP51wTHFr/s80Rx26syPTynRWPD71PUql4ksuzBij
	 e9hvMvdYDSP49D9ZFA==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from [192.168.200.20] ([46.142.32.22]) by mail.gmx.net (mrgmx004
 [212.227.17.190]) with ESMTPSA (Nemesis) id 1M26vL-1ue9sG14Kf-00G6dp; Tue, 15
 Jul 2025 16:53:21 +0200
Message-ID: <de05944d-7775-43da-8b90-54161e35b785@gmx.de>
Date: Tue, 15 Jul 2025 16:53:19 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.15 000/192] 6.15.7-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
References: <20250715130814.854109770@linuxfoundation.org>
From: Ronald Warsow <rwarsow@gmx.de>
Content-Language: de-DE, en-US
In-Reply-To: <20250715130814.854109770@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K1:fD558cLm1hehTFRcs1Mip0yH4zvJ5cqwcBVwGAZPGCUclqWIM4H
 FKx9Ba14wTDwOeVQkjuPeXrryALSS5ZsjTNOhaVpAUMO3lGJRySVwIWXVGPUCNlyo7dZOTU
 Kk4MdKyCGrnH1Hx1vZfQ23XLi7MMhIMJBxn3/WVq/xEEhMh0TKrRKu+9f+YE9wVsRxERPTg
 5+CQ5vaI6inNPO1wvdhNw==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:FqgNm0QlxSk=;oIb0jJIitS3v4JK8vW3eTSCeTMd
 qmaTQ1lY1+L/j1bAWhzlk+DE3ECsVP0SvJfl9xGfgpS9ljVKKqQ9UCTCpDS5M2+kEzbFQyL5c
 aeMW4g4One6a24qhPQ8/qI5VgCgrg14tJ7J57taN0Lxs3ckABAaXhX78asZ1E69D5B1zfUJpi
 tYeqVI+O+EyfA01M2Fs/+atogESfa+rX2dM41M0jwIVVqdaT43VSDFFZbeWOHDqkLXui2uQ9D
 NryTbLdXHCqNkIh875ITv4/Ris+FIBAaIpjAf5sNqDk0d24pjomqJAYWov5MQd5yvfa7Wq1o4
 NgTnmjeSOm+fN9Xlfwxk+PTqlNP2eM8AdkG9+4tdIyDT9r12pdDr+sC80/h4tN3tfiPjFl2Vj
 Dpl7KhPAPT571s4/EevjDUXe2XYTQVtmqN2WaoidMhXeRAJ/yzNzxiYzB0tYHkbWnr2RvsMxm
 K+4arr2p6WqlyyR0IU0A+2w+LdMJAwnUITIP7iLjgp7nOD1dZ9jMcyTLgnKnpiFNU2WZtfr9e
 HdLW3wxwcQ6VNDcQ4V7xvSlB1N8EorfvPaRCPVYgcKkHiF0/kl+qtRtzkZRw6Zi0EkStdy9fb
 i0ji2q5duyeOHFgtrdZ1emZElPbS4cZl20gpVV3Px0QQpL0nP0uCEIJ9GkxeG6W2uJjI4sn9G
 N4DD1lvQYR/qlNkIx+S/nH0KUFvU7gxrQI+fgPn8H/zdifL5mYttx3JBkKffCsWKeuR31sMAY
 5WupbqkbDD0m0i4NkgRqxLbdGCq5C4HfCbSM0rB0FWeTfdSAMkqsf/WCq3emKgDJqZ7AbK4Ti
 edVTHtn0SULJmJV7a857m3oaDKczIoCUg2q7WUKAQdaZVerySqyBYsFf0Gav/vXJOBAfPq+hP
 N/Ww7OGeOXkzPgqbBl52wKrecHuZpErpVXfAOJ5jDdbEf1Lqe/HW6eMmmaOkjdyRGSXYzjzrD
 gB5iomAbNWLLXAMnlG2gFULAbAJMunDPVh5a0BH8OeA/MqTre83z+h95dVTRz61Mb3wXxFPgH
 d+ueQUqE7u+vV5sDBv8c4TKrpvWhaF2dl+GuPkPyfnkcxkvYldAW8CEp1WMDzjqNkJLvpCNhJ
 PtxMoe/8ClLZyFrk3zyzVOua1FvjF8hNCnQaj/vot9K6jR4FxiOSpoQhZDO72wNnYiOUOO0DH
 eRZi9wzT0e136jJE9hMD7CUmvLp+34JKpSPIwT1ADszSt9tO4K7ifBxQCpmZDwgLMKa79DWLt
 10YzRbQKRg+h9XQSTL5Wjkq4KAXtgRcSlKW5Mr4ATJ3UrfdUv4GN3t4b7BcfM6cxoRnv62EAC
 ThSC3LAkR50Ep0xGfjngP9qg702Jiz76DoM4Ku5Jr6VYMMNQRMIvauXBYfoL/NlkO8OL3c+20
 1YH3oDBsWb2Y/UX2MC5mAHfMMicYRqrGdj5gDONvgDwYnLhq1YpnehqX4+oO4jCBG4Tp/iyBO
 j4h3NMX+28hXJXjiJ1zE+FIKGoFQEBNxxN1rCsEJEc2zClheb/cYdSBmSTlilafShpP7hYlKb
 IbxGCs3xWPqMONosaHJbS+ftBJLEkTkCRnWqt7Wxj3d8iQR8zjAfd19pMOFG/nX8LN/o7hVHG
 KM+kFWU/hFYPVgjARke9xU71lkkIhSgWA+6PJVw+RY3aFNqpZvHfp/977z7Ah/PliUClKNC8z
 hnRHgfKjVhQ6cbRWgkQxzaPAXOFlBTE3IaFdrmurnwuXBuLxeBqLhxb9t5MomC4FTE1L/bXLR
 qlNhWjkqjClibxTdW96PG+GhAdy3RELt1QxzpIMrr1h/m9oBhWm7cqvEij2x0RxHdyYfv8zi4
 aPGwTdYQfdBb72XB9oRnFRL7aSf6WF9NBtOu5ZfxSCFoCda/uELbTO+DuUQs6h/mY8teq4vuz
 38q7Qp8oHJsp0F3cRKXdQnNgHkx9pCTWJJ4AljGhvyo0+cuY9KcrEibbuiREZvlLkW9GegjlM
 H7WnlzAR0uI9YyNr+9L9ybSLhdPd7mx+Jw/rpKHDnX08IIDcOBXamESrk+TS2hN5N6cBKeG4L
 T1G61nYbXX4eVQ2wH3y0BmETgkmQ5GyrsUhbKnT/IUl/2eaNFeaQnACrUvPupXtYj+a0iIXga
 PsTCgbXMPiH59QZOZM7Qyga/xOGl/5wbCIhWdsdrn0DuNYV+kW2IJ5t9tkgdhDBInsKp9VQ0u
 sxgALng4Bpdd9W8o/PVTHTk5AOiw/v5IioYZjr/MHPJ1qhZAk5HIhiREyv56gPVILklZCLUoE
 zu74sb02USdLMNem1HNFhy/oVlJyLjzy+e16ywHZnNJKGZdfq5x34o9K47kzg1qaJ5dtdV01b
 2CGwuj1B4ZqFHyF/ZWbjkBZn2LGm8p61cfaK6lxx9/wOGh+jIJYrTUm1d3kLiLqAP3bsjZ2SY
 68jWZIGVZZFzZMDPgHu5hpvqB6O3H6aqZXYA+CJNatKFr1b0ZMzXowj43eRbZLvacr3eKQVeI
 pbM3BAknQrwkVji35LjgFEHeGrPbn88uD82qZ44Vry5UgDo9mEL5LHsdjsGqUECF+d8bbx4Zs
 G47HsxpxvUWN5fwWjYAFR2vbcQ0NeP4Pa4InK6Il001rS1aqc6AUJdlaU2hCyyorU7VDWGgb/
 bnLxA7fg4PDDCRoS/ikS+uDfuCbe1hPmkCWPEfRdVTUSspJ2AHkWNpaMgpbtTRjlLcz3cdUF3
 +seQk1y/7isY/gkP5ooViTQz01Yh3NID/VJ1G67sX0Kwb4/hxasqxyb8vvfhknzbaBELYZ++d
 VfPzuXfn7b3RyGcUnAkugr9haJMSBD2rMW/M2vBIPsZ6djoDBf9aENJG8umdKx0lTTfpmLYnA
 /NVVjolniG+Qn5RPbB8fisOihjY3tk2V5xXFj08c0sJrjmLslFiPkqJrTEGgmyndMJ2TwkMuU
 bFmNBz5QPLjwPLKWGRoCYm/SlybhxgCmu1OSBljwcm5TCSAUwDZtGd/269upUPPgbXhAyUMHJ
 ETwaE0JAcJRbYFRfJTqq7ra7hmgyBVTJRjilTZAvpejquirQXYF+6Q7U6E3upmHNvKS3v9Ywp
 xBoegHSnNXGBuBGRhn3NuD6jGVVIBLKva+h5ZIe9X1ddErKMX9W4dxzTqisg3eLVojloTjNpm
 mlmPhnLexNbb0rDccejIp1VJ5OMjuGfoQXDlwCsftP9QCYm4QrtK5hbIXcfeD2/EwemUn9uOB
 LFSMIxkMx5d8uSy1DrXKZLR3cbMo0vivJWYoXTFOt8QZ2+zTNVwjl+8HBP/D3NMSR/ROQDigl
 0p6P5/EZCzIDxM1I1hEQJ+eqFyX4IAsTS9C7Z+Qo7Xb0sINpjm3ux+y1KmeO424rsRQ4Mq4iW
 qFvyxCddSZW8s8oo/wH2lbBa2gQJCNrnDl3Kb9/ziXlkRAjI6QCOT9ApNCeYvrsp6Md10Z6Hd
 KrqlqjLJ/13NpJW0JDX+WqPqD6RKj+yPBEh8wuLn7i46DuGc/xq1Qpl/7DTr9AMwgR2qN5d15
 nFe2YpFQ2eK8DS39qgIoIF9HhtQZToyEiTvllj35szqk3tsxO4qP8bnuF3l2kkH8eIYM3RsdR
 NMjeCUMBSAskoWUpeA6kd14=

Hi

no regressions here on x86_64 (RKL, Intel 11th Gen. CPU)

Thanks

Tested-by: Ronald Warsow <rwarsow@gmx.de>

